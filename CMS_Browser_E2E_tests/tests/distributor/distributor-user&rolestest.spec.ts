import { test, expect } from '@playwright/test';

test.describe('Distributor user&roles tests', () => {
  test.use({ storageState: 'authd.json' });

  test.beforeEach(async ({ page }) => {
    await page.goto('https://dashboard.cam2drive-bt.com/team/');
  });

  test('should add a new user', async ({ page }) => {
    const randomString = Math.random().toString(36).substring(2, 7);
    const email = `user${randomString}@test.com`;

    await expect(page.getByRole('tab', { name: 'Users' })).toBeVisible();
    await page.getByRole('button', { name: 'Add User' }).click();
    await page.getByRole('textbox', { name: 'Email' }).fill(email);
    await page.getByRole('button').first().click();
    await page.getByRole('option', { name: 'Admin' }).click();
    await page.getByRole('button', { name: 'Submit' }).click();
    await expect(page.getByText('User created successfully')).toBeVisible();
  });

  test('should edit a user role', async ({ page }) => {
    await page.getByRole('link', { name: 'Users & Roles' }).click();
    await page.hover('button:has-text("Edit")');
    await page.getByRole('button', { name: 'Edit' }).click();

    const currentRole = await page.getByRole('button', { name: /Admin|Technician|Viewer/i }).textContent();
    await page.getByRole('button', { name: /Admin|Technician|Viewer/i }).click();

    const roles = ['Admin', 'Technician', 'Viewer'];
    const newRole = roles.find(role => !currentRole?.includes(role))!;

    await page.getByRole('option', { name: newRole }).click();
    await page.getByRole('button', { name: 'Submit' }).click();
    await expect(page.getByText('User updated successfully')).toBeVisible();
  });

  test('should delete a user', async ({ page }) => {
    await page.getByRole('link', { name: 'Users & Roles' }).click();
    await page.hover('button:has-text("Delete")');
    await page.getByRole('button', { name: 'Delete' }).click();
    await expect(page.getByText('Do you really wish to')).toBeVisible();
    await page.getByRole('button', { name: 'delete' }).click();
    await expect(page.getByText('User deleted successfully')).toBeVisible();
  });
});