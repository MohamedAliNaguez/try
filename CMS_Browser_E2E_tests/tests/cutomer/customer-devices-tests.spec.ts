import { test, expect } from '@playwright/test';

test.describe('Customer Device Management', () => {
  test.use({ storageState: 'authd.json' });

  test.beforeEach(async ({ page }) => {
    await page.goto('https://dashboard.cam2drive-bt.com/devices/');
  });

  async function connectAsTestCustomer(page) {
    await expect(page.getByText('dalynaguez@gmail.com', { exact: false })).toBeVisible({ timeout: 300000 });
    await page.getByRole('row', { name: 'dC1XCrwg9Q dalynaguez@gmail.' }).getByRole('button').first().click();
    await expect(page.getByRole('link', { name: 'My Customers' })).toBeVisible();
      await page.getByRole('textbox', { name: 'Email' }).click();
  await page.getByRole('textbox', { name: 'Email' }).fill('tes');
    await expect(page.getByText('Test-Customer test')).toBeVisible();
    await page.getByRole('row', { name: /Test-Customer test/ }).getByRole('button', { name: 'Connect as' }).click();
    await expect(page.getByText('Detections')).toBeVisible();
  }

  test('Add new device', async ({ page }) => {
    await connectAsTestCustomer(page);
    await page.getByRole('link', { name: 'My Devices' }).click();
    await expect(page.getByRole('button', { name: 'Add device' })).toBeVisible();
    await page.getByRole('button', { name: 'Add device' }).click();
    await page.getByText('Swift Minimalist Device Setup').click();
    await page.getByRole('textbox', { name: 'Device Name' }).fill('dev-test');
    await page.getByRole('button', { name: 'Manufacturer' }).click();
    await page.getByRole('option', { name: 'Dahua' }).click();
    await page.getByRole('button', { name: 'Site' }).click();
    await page.getByRole('option').nth(1).click({ force: true });
    await page.getByRole('button', { name: 'Device Type' }).click();
    await page.getByRole('option', { name: 'DVR' }).click();
    await page.getByRole('textbox', { name: 'Number of Channels' }).fill('8');
    await page.getByRole('button', { name: 'Submit' }).click();
    await expect(page.getByText('Congratulations ! Your Device')).toBeVisible();
    await page.locator('div').filter({ hasText: 'Congratulations ! Your Device' }).nth(1).click();
  });

  test('Delete device', async ({ page }) => {
    await connectAsTestCustomer(page);
    await page.getByRole('link', { name: 'My Devices' }).click();
    await expect(page.getByRole('button', { name: 'Add device' })).toBeVisible();
    await page.hover('button:has-text("Delete")');
    await page.getByRole('button', { name: 'Delete' }).click();
    await expect(page.getByText('Are you sure you want to')).toBeVisible();
    await page.getByRole('button', { name: 'Delete' }).click();
    await expect(page.getByText('Device deleted successfully')).toBeVisible();
  });
});