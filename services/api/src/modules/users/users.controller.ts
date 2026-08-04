import { Controller, Get, Put, Post, Delete, Body, Param, Query } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { UsersService, UserProfileDto, UserAddressDto, NotificationSettingsDto } from './users.service';

@ApiTags('Users & Profile')
@Controller()
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('profile')
  @ApiOperation({ summary: 'Get current customer profile details' })
  async getProfile(@Query('userId') userId?: string) {
    return this.usersService.getProfile(userId);
  }

  @Put('profile')
  @ApiOperation({ summary: 'Update customer profile information' })
  async updateProfile(@Query('userId') userId: string, @Body() body: Partial<UserProfileDto>) {
    return this.usersService.updateProfile(userId, body);
  }

  @Get('addresses')
  @ApiOperation({ summary: 'Get saved user delivery addresses' })
  async getAddresses(@Query('userId') userId?: string) {
    return this.usersService.getAddresses(userId);
  }

  @Post('addresses')
  @ApiOperation({ summary: 'Create new user delivery address' })
  async createAddress(@Query('userId') userId: string, @Body() body: UserAddressDto) {
    return this.usersService.createAddress(userId, body);
  }

  @Put('addresses/:id')
  @ApiOperation({ summary: 'Update existing user delivery address' })
  async updateAddress(
    @Query('userId') userId: string,
    @Param('id') id: string,
    @Body() body: Partial<UserAddressDto>,
  ) {
    return this.usersService.updateAddress(userId, id, body);
  }

  @Delete('addresses/:id')
  @ApiOperation({ summary: 'Delete user delivery address' })
  async deleteAddress(@Query('userId') userId: string, @Param('id') id: string) {
    return this.usersService.deleteAddress(userId, id);
  }

  @Get('settings')
  @ApiOperation({ summary: 'Get user notification preferences and settings' })
  async getSettings(@Query('userId') userId?: string) {
    return this.usersService.getSettings(userId);
  }

  @Put('settings')
  @ApiOperation({ summary: 'Update user notification preferences and settings' })
  async updateSettings(@Query('userId') userId: string, @Body() body: Partial<NotificationSettingsDto>) {
    return this.usersService.updateSettings(userId, body);
  }

  @Post('change-password')
  @ApiOperation({ summary: 'Change account security password' })
  async changePassword(
    @Query('userId') userId: string,
    @Body() body: { currentPass: string; newPass: string },
  ) {
    return this.usersService.changePassword(userId, body);
  }

  @Post('logout-all')
  @ApiOperation({ summary: 'Revoke and log out across all active sessions' })
  async logoutAll(@Query('userId') userId?: string) {
    return this.usersService.logoutAll(userId);
  }

  @Get('privacy-policy')
  @ApiOperation({ summary: 'Get production Privacy Policy' })
  async getPrivacyPolicy() {
    return this.usersService.getPrivacyPolicy();
  }

  @Get('terms')
  @ApiOperation({ summary: 'Get production Terms of Service' })
  async getTermsOfService() {
    return this.usersService.getTermsOfService();
  }

  @Post('accept-terms')
  @ApiOperation({ summary: 'Record user terms/privacy acceptance consent' })
  async acceptTerms(
    @Query('userId') userId: string,
    @Body() body: { version: string; type: 'PRIVACY' | 'TERMS' },
  ) {
    return this.usersService.acceptTerms(userId, body);
  }

  @Post('delete-account')
  @ApiOperation({ summary: 'Request account deletion & soft delete user' })
  async deleteAccount(
    @Query('userId') userId: string,
    @Body() body: { reason: string; confirmPass?: string },
  ) {
    return this.usersService.deleteAccount(userId, body);
  }
}
