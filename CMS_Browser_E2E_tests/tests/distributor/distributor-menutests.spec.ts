import { test, expect } from '@playwright/test';

test.describe('Distrobutor Installers menu tests', () => {
  test.use({ storageState: 'authd.json' });

  test.beforeEach(async ({ page }) => {
    await page.goto('https://dashboard.cam2drive-bt.com/customers/');
  });

  function getRandomString(length = 10) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    return Array.from({ length }, () => chars[Math.floor(Math.random() * chars.length)]).join('');
  }

  test('Verify the display of installers list', async ({ page }) => {
    await page.getByRole('link', { name: 'My Installers' }).click();
    await expect(page.getByText('Installers', { exact: true })).toBeVisible();
    await expect(page.getByRole('button', { name: 'Add Installer' })).toBeVisible();
    await expect(page.getByText('Rows per page:')).toBeVisible();
  });

  test('Verify the display of "Users & Roles"', async ({ page }) => {
    await page.getByRole('link', { name: 'Users & Roles' }).click();
    await expect(page.getByRole('tab', { name: 'Users' })).toBeVisible();
    await expect(page.getByRole('tab', { name: 'Roles' })).toBeVisible();
    await expect(page.getByRole('button', { name: 'Add User' })).toBeVisible();
    await expect(page.getByText('Email')).toBeVisible();
    await expect(page.getByText('Role', { exact: true })).toBeVisible();
    await expect(page.getByText('Actions')).toBeVisible();
  });

  test('Add new installer', async ({ page }) => {
    await page.getByRole('button', { name: 'Add Installer' }).click();
    await expect(page.getByRole('heading', { name: 'Add new installer' })).toBeVisible();

    const randomString = Math.random().toString(36).substring(2, 7);
    const company = `Company-${randomString}`;
    const email = `user${randomString}@test.com`;
    const phone = Math.floor(10000000 + Math.random() * 90000000).toString();

    await page.getByRole('textbox', { name: 'Company' }).fill(company);
    await page.getByRole('textbox', { name: 'Email' }).fill(email);
    await page.getByRole('textbox', { name: 'Phone Number' }).fill(phone);
    await page.getByRole('button', { name: 'Submit' }).click();
    await expect(page.getByText('installer created successfully')).toBeVisible();
  });

  test('edit installer', async ({ page }) => {
    await expect(page.getByText('Installers', { exact: true })).toBeVisible();
    await expect(page.getByRole('button', { name: 'Edit' }).nth(2)).toBeVisible();
    await page.getByRole('button', { name: 'Edit' }).first().click();
    await expect(page.getByRole('heading', { name: 'Edit installer' })).toBeVisible();
    await page.getByRole('textbox', { name: 'Company' }).click();
    await page.getByRole('textbox', { name: 'Company' }).fill(getRandomString());
    await page.getByRole('button', { name: 'Submit' }).click();
    await expect(page.getByText('installer updated successfully')).toBeVisible();
  });
});