import { test as setup, expect } from "@playwright/test";

setup("log in once as the seeded user", async ({ page }) => {
  await page.goto("/login");
  await page.getByLabel("Email").fill(process.env.CARRY_UI_USER ?? "TODO seeded user from the repo's seed");
  await page.getByLabel("Password").fill(process.env.CARRY_UI_PASS ?? "TODO seeded password from the repo's seed");
  await page.getByRole("button", { name: "Log in" }).click();
  await expect(page.getByRole("navigation")).toBeVisible();
  await page.context().storageState({ path: `${__dirname}/.auth/user.json` });
});
