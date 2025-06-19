import { test, expect } from '@playwright/test';

test.describe('Installer Customers menu', () => {
  test.use({ storageState: 'auth.json' });

  test.beforeEach(async ({ page }) => {
    await page.goto('https://dashboard.cam2drive-bt.com/customers/');
  });

  function randomString(length = 5) {
    return Math.random().toString(36).substring(2, 2 + length);
  }

  function randomName(base = 'ahmed aziz') {
    return `${base}-${Math.random().toString(36).substring(2, 6)}`;
  }

  test('should add a new customer', async ({ page }) => {
    const firstName = `amine${randomString()}`;
    const lastName = `mejri${randomString()}`;
    const email = `${firstName}.${lastName}@gmail.com`;

    await page.getByRole('button', { name: 'Add Customer' }).click();
    await page.getByRole('textbox', { name: 'First Name' }).fill(firstName);
    await page.getByRole('textbox', { name: 'Last Name' }).fill(lastName);
    await page.getByRole('textbox', { name: 'Email' }).fill(email);
    await page.getByRole('button', { name: 'Submit' }).click();
  await expect(page.getByText('customer created successfully')).toBeVisible();
  });

  test('should edit a customer', async ({ page }) => {
    const newName = randomName();

    await page.getByRole('button', { name: 'Edit' }).first().click();
    await expect(page.getByRole('tab', { name: 'Customer Infos' })).toBeVisible();
    await page.getByRole('textbox').first().fill(newName);
    await page.getByRole('button', { name: 'Save' }).click();
    await expect(page.getByText('customer updated successfully')).toBeVisible();
  });
});