import { test, expect } from '@playwright/test';

test.describe('Distributor Authentication Tests', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('https://dashboard.cam2drive-bt.com/login/');
  });

  test('Login with valid credentials', async ({ page }) => {
    await page.getByRole('textbox', { name: 'Email' }).fill('dalynaguez@gmail.com');
    await page.getByRole('textbox', { name: 'Password' }).fill('Sennanolight1*');
    await page.getByRole('button', { name: 'Login' }).click();
    await expect(page.getByRole('link', { name: 'My Customers' })).toBeVisible();
  });

  test('Login with invalid email', async ({ page }) => {
    await page.getByRole('textbox', { name: 'Email' }).fill('daly.naguez@gmail.com');
    await page.getByRole('textbox', { name: 'Password' }).fill('Sennanolight1*');
    await page.getByRole('button', { name: 'Login' }).click();
    await expect(page.getByText('Email or Password is invalid')).toBeVisible();
  });

  test('Login with empty fields', async ({ page }) => {
    await page.getByRole('button', { name: 'Login' }).click();
    await expect(page.getByText('Field \'Email\' is required')).toBeVisible();
    await expect(page.getByText('Field \'Password\' is required')).toBeVisible();
  });

  test('Login with incorrectly formatted email', async ({ page }) => {
    await page.getByRole('textbox', { name: 'Email' }).fill('daly.naguez');
    await page.getByRole('textbox', { name: 'Password' }).fill('Sennanolight1*');
    await page.getByRole('button', { name: 'Login' }).click();
    await expect(page.getByText('Email must be valid')).toBeVisible();
  });

  test('Wrong password', async ({ page }) => {
    await page.getByRole('textbox', { name: 'Email' }).fill('dalynaguez@gmail.com');
    await page.getByRole('textbox', { name: 'Password' }).fill('Sennanolight');
    await page.getByRole('button', { name: 'Login' }).click();
    await expect(page.getByText('Email or Password is invalid')).toBeVisible();
  });

  test('Forgot Password', async ({ page }) => {
    await page.getByRole('textbox', { name: 'Email' }).fill('dalynaguez@gmail.com');
    await page.getByText('Forgot Password?').click();
    await page.getByRole('button', { name: 'Send Email' }).click();
    await expect(page.getByText('Reset password email sent')).toBeVisible();
  });
});