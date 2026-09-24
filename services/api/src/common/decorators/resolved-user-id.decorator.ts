import { createParamDecorator, ExecutionContext } from '@nestjs/common';

export const GUEST_USER_ID = 'usr_default';

/**
 * Resolves the effective user id for a request:
 *   - authenticated  -> id from the verified JWT (req.user.id)
 *   - guest          -> the shared guest id
 *
 * The client-supplied `userId` query/body param is intentionally ignored, so it
 * cannot be used to access another account's cart, orders, or addresses.
 * Use together with @UseGuards(OptionalJwtAuthGuard).
 */
export const ResolvedUserId = createParamDecorator((_data: unknown, ctx: ExecutionContext): string => {
  const request = ctx.switchToHttp().getRequest();
  return request.user?.id || GUEST_USER_ID;
});
