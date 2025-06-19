import { test, expect } from '@playwright/test';
import { login, TEST_EMAIL , TEST_PASSWORD } from '../utils';

test('Login and save session', async ({ page }) => {
  await page.goto('https://dashboard.cam2drive-bt.com/login');

  await login(page, TEST_EMAIL, TEST_PASSWORD);

  // Wait for a specific element that appears only after login
  await page.waitForSelector('text=Customers', { timeout: 300000 }); // waits up to 30 seconds

  await expect(page.getByText('Customers', { exact: true })).toBeVisible();

  await page.context().storageState({ path: 'auth.json' });
});
