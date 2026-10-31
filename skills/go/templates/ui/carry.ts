import { test as base, expect, type Page } from "@playwright/test";
import { mkdirSync } from "node:fs";

const out = process.env.CARRY_UI_OUT ?? "test-results";

export const test = base.extend<{ shot: (box: string, label: string) => Promise<string> }>({
  shot: async ({ page }, use) => {
    mkdirSync(out, { recursive: true });
    await use(async (box, label) => {
      const path = `${out}/${box}-${label}.png`;
      await page.screenshot({ path, fullPage: true });
      return path;
    });
  },
});

export async function api(page: Page, method: string, path: string, data?: unknown) {
  const res = await page.request.fetch(path, { method, data });
  expect(res.ok(), `${method} ${path} -> ${res.status()}`).toBeTruthy();
  return res.json().catch(() => ({}));
}

export { expect };
