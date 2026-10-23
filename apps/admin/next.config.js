/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  transpilePackages: [
    '@daily-basket/api-client',
    '@daily-basket/constants',
    '@daily-basket/shared-types',
    '@daily-basket/shared-utils',
  ],
};

module.exports = nextConfig;
