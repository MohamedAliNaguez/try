import { test, expect } from '@playwright/test';

test.describe('Customer Sites managemment', () => {
  test.use({ storageState: 'authd.json' });

  test.beforeEach(async ({ page }) => {
    await page.goto('https://dashboard.cam2drive-bt.com/devices/');
  });

  async function connectAsTestCustomer(page) {
    await expect(page.getByText('distributor')).toBeVisible();
    await expect(page.getByText('dalynaguez@gmail.com')).toBeVisible();
    await page.getByRole('row', { name: 'dC1XCrwg9Q dalynaguez@gmail.' }).getByRole('button').first().click();
    await expect(page.getByRole('link', { name: 'My Customers' })).toBeVisible();
      await page.getByRole('textbox', { name: 'Email' }).click();
  await page.getByRole('textbox', { name: 'Email' }).fill('tes');
    await expect(page.getByText('Test-Customer test')).toBeVisible();
    await page.getByRole('row', { name: /Test-Customer test/ }).getByRole('button', { name: 'Connect as' }).click();
    await expect(page.getByText('Detections')).toBeVisible();
  }

  test('add site', async ({ page }) => {
    const siteName = `site-${Math.floor(Math.random() * 10000)}`;
    const address = `${Math.floor(Math.random() * 1000)} Main St, Springfield`;

    await connectAsTestCustomer(page);
    await page.getByRole('link', { name: 'My Sites' }).click();
    await expect(page.getByText('Sites', { exact: true })).toBeVisible();
    await page.getByRole('button', { name: 'Add Site' }).click();
    await page.getByRole('textbox', { name: 'Name' }).fill(siteName);
    await page.getByRole('textbox', { name: 'Address' }).fill(address);
    await page.getByRole('button', { name: 'Submit' }).click();
    await expect(page.getByText('Site created successfully')).toBeVisible();
  });

  test('delete site', async ({ page }) => {
    await connectAsTestCustomer(page);
    await page.getByRole('link', { name: 'My Sites' }).click();
    await expect(page.getByText('Sites', { exact: true })).toBeVisible();
    await expect(page.getByText('UTC').first()).toBeVisible();

    const deleteButtons = page.locator('button:has-text("Delete")');
    await deleteButtons.nth(1).hover();
    await deleteButtons.nth(1).click();
    await page.getByRole('button', { name: 'delete' }).click();
    // await expect(page.getByText('Site deleted successfully')).toBeVisible();
  });
});