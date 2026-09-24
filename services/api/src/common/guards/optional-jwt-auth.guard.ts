import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

/**
 * Optional JWT authentication.
 *
 * - Valid Bearer token  -> req.user is populated (authenticated).
 * - No / invalid token   -> request proceeds as a guest (req.user stays undefined).
 *
 * Never throws, so guest flows keep working. Combined with @ResolvedUserId(),
 * the effective user id always comes from the verified token (or the shared
 * guest id) and never from a client-supplied parameter — closing the IDOR where
 * a caller could pass another user's id to read/modify their data.
 */
@Injectable()
export class OptionalJwtAuthGuard extends AuthGuard('jwt') {
  handleRequest(_err: any, user: any) {
    return user || null;
  }
}
