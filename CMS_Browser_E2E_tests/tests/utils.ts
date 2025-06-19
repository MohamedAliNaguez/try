import { Page } from '@playwright/test';
import * as dotenv from 'dotenv';
dotenv.config();

export const TEST_EMAIL = process.env.TEST_EMAIL!;
export const TEST_EMAILD = process.env.TEST_EMAILD!;

export const TEST_PASSWORD = process.env.TEST_PASSWORD!;
export async function login(page: Page, email: string, password: string) {
  await page.goto('https://dashboard.cam2drive-bt.com/login');
  await page.getByRole('textbox', { name: 'Email' }).fill(email);
  await page.getByRole('textbox', { name: 'Password' }).fill(password);
  await page.getByRole('button', { name: 'Login' }).click();
}

export function randomString(length = 5) {
  return Math.random().toString(36).substring(2, 2 + length);
}

export function randomEmail(prefix = 'user') {
  return `${prefix}${randomString()}@test.com`;
}