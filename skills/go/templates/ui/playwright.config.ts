import { defineConfig, devices } from "@playwright/test";

export default defineConfig({
  testDir: __dirname,
  testMatch: /.*\.spec\.ts$/,
  fullyParallel: true,
  retries: 1,
  timeout: 30_000,
  expect: { timeout: 5_000 },
  reporter: [["line"]],
  outputDir: `${process.env.CARRY_UI_OUT ?? "test-results"}/playwright`,
  use: {
    baseURL: process.env.BASE_URL,
    headless: true,
    trace: "retain-on-failure",
    screenshot: "off",
    video: "off",
  },
  projects: [
    { name: "setup", testMatch: /auth\.setup\.ts$/, testDir: __dirname },
    {
      name: "chromium",
      use: { ...devices["Desktop Chrome"], storageState: `${__dirname}/.auth/user.json` },
      dependencies: ["setup"],
    },
  ],
});
