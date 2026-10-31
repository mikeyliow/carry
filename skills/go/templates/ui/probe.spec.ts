import { test, expect } from "./carry";

test("probe: the app loads logged in", async ({ page, shot }) => {
  await page.goto("/");
  await expect(page.getByRole("navigation")).toBeVisible();
  await shot("probe", "home");
});
