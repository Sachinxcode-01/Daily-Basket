import { Injectable, ExecutionContext, UnauthorizedException } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  canActivate(context: ExecutionContext) {
    return super.canActivate(context);
  }

  handleRequest(err: any, user: any, info: any) {
    if (err || !user) {
      // Classify errors to give users clearer feedback without revealing internals
      if (info?.name === 'TokenExpiredError' || (info as any)?.name === 'TokenExpiredError') {
        throw new UnauthorizedException('Authentication token has expired. Please sign in again.');
      }
      throw new UnauthorizedException('Invalid authentication token.');
    }
    return user;
  }
}
