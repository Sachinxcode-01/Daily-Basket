/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  transpilePackages: [
    '@daily-basket/api-client',
    '@daily-basket/constants',
    '@daily-basket/design-system',
    '@daily-basket/shared-types',
    '@daily-basket/shared-utils',
    '@daily-basket/theme',
  ],
};

module.exports = nextConfig;
