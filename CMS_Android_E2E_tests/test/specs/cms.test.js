describe('ACOBA Cam2Drive CMS', () => {
  it('Should show Login page', async () => {
    // Check for the logo or a unique element
    const imageView = await $('android=new UiSelector().className("android.widget.ImageView")');
    await expect(imageView).toBeDisplayed();

    // Check for the first EditText (username)
    const usernameInput = await $('android=new UiSelector().className("android.widget.EditText").instance(0)');
    await expect(usernameInput).toBeDisplayed();

    // Check for the second EditText (password)
    const passwordInput = await $('android=new UiSelector().className("android.widget.EditText").instance(1)');
    await expect(passwordInput).toBeDisplayed();

    const loginButton = await $('~Login');
    await expect(loginButton).toBeDisplayed();
  });
  
 it('Shouldnt Login', async () => {
    // Enter username
    const usernameInput = await $('android=new UiSelector().className("android.widget.EditText").instance(0)');
    await usernameInput.click();
    await usernameInput.clearValue();
    await usernameInput.setValue('wrong@test.com');
    await driver.pause(300); 

    // Enter password
    const passwordInput = await $('android=new UiSelector().className("android.widget.EditText").instance(1)');
    await passwordInput.click();
    await passwordInput.clearValue();
    await passwordInput.setValue('$Acoba12345wrong');
    await driver.pause(300); 

    // Click the Login button
    const loginButton = await $('~Login');
    await loginButton.click();
    await driver.pause(300); 

    await expect(loginButton).toBeDisplayed();
});

 it('Should Login', async () => {
    // Enter username
    const usernameInput = await $('android=new UiSelector().className("android.widget.EditText").instance(0)');
    await usernameInput.click();
    await usernameInput.clearValue();
    await usernameInput.setValue('tratest@test.com');
    await driver.pause(300); 

    // Enter password
    const passwordInput = await $('android=new UiSelector().className("android.widget.EditText").instance(1)');
    await passwordInput.click();
    await passwordInput.clearValue();
    await passwordInput.setValue('$Acoba12345');
    await driver.pause(300); 

    // Click the Login button
    const loginButton = await $('~Login');
    await loginButton.click();

    await expect(loginButton).not.toBeDisplayed();
});
   it('Should open Select Camera interface from  search icon', async () => {
    const cameraView = await $('android=new UiSelector().className("android.view.View").instance(7)');
    await cameraView.click();

    const elements = [
      '~Validate',
      '~Clear',
      '~Select Site:',
      '~Select Device:',
      '~Select Channel:',
      '~Select Date:',
      '~Select Time:'
    ];

    for (const selector of elements) {
      const el = await $(selector);
      await expect(el).toBeDisplayed();
    }
  });
  it('Should open menu and display all items', async () => {
    await driver.back();
    const menuButton = await $('android=new UiSelector().className("android.widget.Button").instance(0)');
    await menuButton.click();

    const menuItems = ['~Select a camera', '~Change Password', '~Logout'];
    for (const selector of menuItems) {
      const item = await $(selector);
      await expect(item).toBeDisplayed();
    }
  });



    it('Should open Select Camera from menu', async () => {
    const selectCamera = await $('~Select a camera');
    await selectCamera.click();

    const elements = [
      '~Validate',
      '~Clear',
      '~Select Site:',
      '~Select Device:',
      '~Select Channel:',
      '~Select Date:',
      '~Select Time:'
    ];

    for (const selector of elements) {
      const el = await $(selector);
      await expect(el).toBeDisplayed();
    }
  });
 
  it('Should open Change Password screen and show required fields', async () => {
    await driver.back();
    const menuButton = await $('android=new UiSelector().className("android.widget.Button").instance(0)');
    await menuButton.click();

    const changePasswordMenu = await $('~Change Password');
    await changePasswordMenu.click();

    const title = await $('android=new UiSelector().description("Change Password")');
    const suggestion = await $('~We suggest rotating your password often to ensure your security.');
    const oldPw = await $('android=new UiSelector().className("android.widget.EditText").instance(0)');
    const newPw = await $('android=new UiSelector().className("android.widget.EditText").instance(1)');
    const confirmPw = await $('android=new UiSelector().className("android.widget.EditText").instance(2)');
    const submitBtn = await $('android=new UiSelector().description("Change Password")');

    await expect(title).toBeDisplayed();
    await expect(suggestion).toBeDisplayed();
    await expect(oldPw).toBeDisplayed();
    await expect(newPw).toBeDisplayed();
    await expect(confirmPw).toBeDisplayed();
    await expect(submitBtn).toBeDisplayed();
  });
 it('Should logout and return to login page', async () => {
    await driver.back();
    const menuButton = await $('android=new UiSelector().className("android.widget.Button").instance(0)');
    await menuButton.click();

    const logout = await $('~Logout');
    await logout.click();

    const loginButton = await $('~Login');
    await expect(loginButton).toBeDisplayed();
  });
 
});