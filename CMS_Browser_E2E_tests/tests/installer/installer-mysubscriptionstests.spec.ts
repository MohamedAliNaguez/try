import { test, expect, Page } from '@playwright/test';

async function goToMySubscriptions(page: Page) {
  await page.getByRole('button', { name: 'My Subscriptions' }).click();
}

test.describe('Installer subscription tests', () => {
  test.use({ storageState: 'auth.json' });

  test.beforeEach(async ({ page }) => {
    await page.goto('https://dashboard.cam2drive-bt.com/customers/');
  });

  test('should show Virtual Drives and AI Subscriptions links', async ({ page }) => {
    await goToMySubscriptions(page);
    await expect(page.getByRole('link', { name: 'Virtual Drives' })).toBeVisible();
    await expect(page.getByRole('link', { name: 'AI Subscriptions' })).toBeVisible();
  });

  test('should add a virtual drive', async ({ page }) => {
    await goToMySubscriptions(page);
    await page.getByRole('link', { name: 'Virtual Drives' }).click();
    await page.getByRole('button', { name: 'Add drive' }).click();
    await page.getByRole('button', { name: 'Customer' }).click();
    await page.getByRole('option', { name: 'Test-Customer test' }).click();
    await page.getByRole('button', { name: 'Associated Device' }).click();
    await page.getByRole('option').first().click();
    await page.getByRole('button', { name: 'Continue' }).click();
    await expect(page.getByRole('heading', { name: 'AC_ST_50' })).toBeVisible();
    await page.getByText('AC_ST_5050 GB of secure cloud storage for essential event data.50 GB50 GB of').click();
    await page.getByRole('button', { name: 'Select' }).first().click();
    await page.getByRole('button', { name: 'Submit' }).click();
  });

  test('should add an AI subscription', async ({ page }) => {
    await goToMySubscriptions(page);
    await page.getByRole('link', { name: 'AI Subscriptions' }).click();
    await page.getByRole('button', { name: 'Add AI' }).click();
    await page.getByRole('button', { name: 'Customer' }).click();
    await page.getByRole('option').first().click();
    await page.getByRole('button', { name: 'Billing period' }).click();
    await page.getByRole('option', { name: 'Monthly' }).click();
    await page.getByRole('button', { name: 'Submit' }).click();
    await expect(page.getByText('AI Subscription created')).toBeVisible();
  });
});