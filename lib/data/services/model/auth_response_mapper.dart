import '../../../domain/models/auth_response_model.dart';
import '../../../domain/models/session_model.dart';
import '../../../domain/models/user_model.dart';

/// Maps Supabase AuthResponse-like objects to domain models.
/// The Supabase package returns complex objects; we transform them to simple
/// JSON-compatible maps and then use the domain model factories.
class AuthResponseMapper {
  static AuthResponseModel fromSupabase(dynamic res) {
    if (res == null) return const AuthResponseModel();

    final user = mapUser(res.user);
    final session = mapSession(res.session);

    return AuthResponseModel(user: user, session: session);
  }

  static UserModel? mapUser(dynamic user) {
    if (user == null) return null;
    return UserModel(
      id: user.id ?? '',
      aud: user.aud,
      role: user.role,
      email: user.email,
      emailConfirmedAt: user.emailConfirmedAt,
      phone: user.phone,
      lastSignInAt: user.lastSignInAt,
      appMetadata: user.appMetadata != null ? Map<String, dynamic>.from(user.appMetadata) : null,
      userMetadata: user.userMetadata != null ? Map<String, dynamic>.from(user.userMetadata) : null,
      createdAt: user.createdAt != null ? DateTime.tryParse(user.createdAt.toString()) : null,
      updatedAt: user.updatedAt != null ? DateTime.tryParse(user.updatedAt.toString()) : null,
    );
  }

  static SessionModel? mapSession(dynamic session) {
    if (session == null) return null;
    return SessionModel(
      accessToken: session.accessToken,
      tokenType: session.tokenType,
      expiresIn: session.expiresIn,
      refreshToken: session.refreshToken,
      user: mapUser(session.user),
    );
  }
}
