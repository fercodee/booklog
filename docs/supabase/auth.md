# Feature Auth

> Link para documentação: https://supabase.com/docs/reference/dart/start

## Cadastro usuário com email e password

```dart

final AuthResponse res = await supabase.auth.signUp(
  email: 'example@email.com',
  password: 'example-password',
);
final Session? session = res.session;
final User? user = res.user;


// Response Cadastro Usuário:

// Some fields may be null if "confirm email" is enabled.
AuthResponse(
  user: const User(
    id: '11111111-1111-1111-1111-111111111111',
    aud: 'authenticated',
    role: 'authenticated',
    email: 'example@email.com',
    emailConfirmedAt: '2024-01-01T00:00:00Z',
    phone: '',
    lastSignInAt: '2024-01-01T00:00:00Z',
    appMetadata: {
      'provider': 'email',
      'providers': ['email']
    },
    userMetadata: {},
    identities: [
      UserIdentity(
        identityId: '22222222-2222-2222-2222-222222222222',
        id: '11111111-1111-1111-1111-111111111111',
        userId: '11111111-1111-1111-1111-111111111111',
        identityData: {
          'email': 'example@email.com',
          'email_verified': false,
          'phone_verified': false,
          'sub': '11111111-1111-1111-1111-111111111111'
        },
        provider: 'email',
        lastSignInAt: '2024-01-01T00:00:00Z',
        createdAt: '2024-01-01T00:00:00Z',
        updatedAt: '2024-01-01T00:00:00Z',
      ),
    ],
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-01T00:00:00Z',
  ),
  session: Session(
    accessToken: '<ACCESS_TOKEN>',
    tokenType: 'bearer',
    expiresIn: 3600,
    refreshToken: '<REFRESH_TOKEN>',
    user: const User(
      id: '11111111-1111-1111-1111-111111111111',
      aud: 'authenticated',
      role: 'authenticated',
      email: 'example@email.com',
      emailConfirmedAt: '2024-01-01T00:00:00Z',
      phone: '',
      lastSignInAt: '2024-01-01T00:00:00Z',
      appMetadata: {
        'provider': 'email',
        'providers': ['email']
      },
      userMetadata: {},
      identities: [
        UserIdentity(
          identityId: '22222222-2222-2222-2222-222222222222',
          id: '11111111-1111-1111-1111-111111111111',
          userId: '11111111-1111-1111-1111-111111111111',
          identityData: {
            'email': 'example@email.com',
            'email_verified': false,
            'phone_verified': false,
            'sub': '11111111-1111-1111-1111-111111111111'
          },
          provider: 'email',
          lastSignInAt: '2024-01-01T00:00:00Z',
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-01T00:00:00Z',
        )
      ],
      createdAt: '2024-01-01T00:00:00Z',
      updatedAt: '2024-01-01T00:00:00Z',
    ),
  ),
);

```
### Eventos de autenticação

```dart

final authSubscription = supabase.auth.onAuthStateChange.listen((data) {
  final AuthChangeEvent event = data.event;
  final Session? session = data.session;
  print('event: $event, session: $session');
  switch (event) {
    case AuthChangeEvent.initialSession:
    // handle initial session
    case AuthChangeEvent.signedIn:
    // handle signed in
    case AuthChangeEvent.signedOut:
    // handle signed out
    case AuthChangeEvent.passwordRecovery:
    // handle password recovery
    case AuthChangeEvent.tokenRefreshed:
    // handle token refreshed
    case AuthChangeEvent.userUpdated:
    // handle user updated
    case AuthChangeEvent.userDeleted:
    // handle user deleted
    case AuthChangeEvent.mfaChallengeVerified:
    // handle mfa challenge verified
  }
});

```

### Login com email e password

```dart

final AuthResponse res = await supabase.auth.signInWithPassword(
  email: 'example@email.com',
  password: 'example-password',
);
final Session? session = res.session;
final User? user = res.user;

// Response login:

AuthResponse(
  user: const User(
    id: '11111111-1111-1111-1111-111111111111',
    aud: 'authenticated',
    role: 'authenticated',
    email: 'example@email.com',
    emailConfirmedAt: '2024-01-01T00:00:00Z',
    phone: '',
    lastSignInAt: '2024-01-01T00:00:00Z',
    appMetadata: {
      'provider': 'email',
      'providers': ['email']
    },
    userMetadata: {},
    identities: [
      UserIdentity(
        identityId: '22222222-2222-2222-2222-222222222222',
        id: '11111111-1111-1111-1111-111111111111',
        userId: '11111111-1111-1111-1111-111111111111',
        identityData: {
          'email': 'example@email.com',
          'email_verified': false,
          'phone_verified': false,
          'sub': '11111111-1111-1111-1111-111111111111'
        },
        provider: 'email',
        lastSignInAt: '2024-01-01T00:00:00Z',
        createdAt: '2024-01-01T00:00:00Z',
        updatedAt: '2024-01-01T00:00:00Z',
      ),
    ],
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-01T00:00:00Z',
  ),
  session: Session(
    accessToken: '<ACCESS_TOKEN>',
    tokenType: 'bearer',
    expiresIn: 3600,
    refreshToken: '<REFRESH_TOKEN>',
    user: const User(
      id: '11111111-1111-1111-1111-111111111111',
      aud: 'authenticated',
      role: 'authenticated',
      email: 'example@email.com',
      emailConfirmedAt: '2024-01-01T00:00:00Z',
      phone: '',
      lastSignInAt: '2024-01-01T00:00:00Z',
      appMetadata: {
        'provider': 'email',
        'providers': ['email']
      },
      userMetadata: {},
      identities: [
        UserIdentity(
          identityId: '22222222-2222-2222-2222-222222222222',
          id: '11111111-1111-1111-1111-111111111111',
          userId: '11111111-1111-1111-1111-111111111111',
          identityData: {
            'email': 'example@email.com',
            'email_verified': false,
            'phone_verified': false,
            'sub': '11111111-1111-1111-1111-111111111111'
          },
          provider: 'email',
          lastSignInAt: '2024-01-01T00:00:00Z',
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-01T00:00:00Z',
        )
      ],
      createdAt: '2024-01-01T00:00:00Z',
      updatedAt: '2024-01-01T00:00:00Z',
    ),
  ),
);

```

### Deslogar o usuário

```dart

await supabase.auth.signOut();

```

### Recuperar sessão

> Retorna os dados da sessão, caso haja uma sessão ativa.

```dart

final Session? session = supabase.auth.currentSession;

```

### Recuperar nova sessão

> Este método irá atualizar e retornar uma nova sessão, independentemente de a sessão atual estar expirada ou não.

```dart

final Session? session = supabase.auth.currentSession;

```

### Recuperar usuário

```dart
final User? user = supabase.auth.currentUser;

// Response recuperar usuário:

User(
  id: '11111111-1111-1111-1111-111111111111',
  aud: 'authenticated',
  role: 'authenticated',
  email: 'example@email.com',
  emailConfirmedAt: '2024-01-01T00:00:00Z',
  phone: '',
  lastSignInAt: '2024-01-01T00:00:00Z',
  appMetadata: {
    'provider': 'email',
    'providers': ['email']
  },
  userMetadata: {},
  identities: [
    UserIdentity(
      identityId: '22222222-2222-2222-2222-222222222222',
      id: '11111111-1111-1111-1111-111111111111',
      userId: '11111111-1111-1111-1111-111111111111',
      identityData: {
        'email': 'example@email.com',
        'email_verified': false,
        'phone_verified': false,
        'sub': '11111111-1111-1111-1111-111111111111'
      },
      provider: 'email',
      lastSignInAt: '2024-01-01T00:00:00Z',
      createdAt: '2024-01-01T00:00:00Z',
      updatedAt: '2024-01-01T00:00:00Z',
    )
  ],
  createdAt: '2024-01-01T00:00:00Z',
  updatedAt: '2024-01-01T00:00:00Z',
);

```
### Update usuário

```dart

// Campos que podem ser mudados: email, phone e password

final UserResponse res = await supabase.auth.updateUser(
  UserAttributes(
    email: 'example@email.com',
  ),
);
final User? updatedUser = res.user;

// Response

UserResponse(
  user: const User(
    id: '11111111-1111-1111-1111-111111111111',
    aud: 'authenticated',
    role: 'authenticated',
    email: 'example@email.com',
    emailConfirmedAt: '2024-01-01T00:00:00Z',
    phone: '',
    lastSignInAt: '2024-01-01T00:00:00Z',
    appMetadata: {
      'provider': 'email',
      'providers': ['email']
    },
    userMetadata: {},
    identities: [
      UserIdentity(
        identityId: '22222222-2222-2222-2222-222222222222',
        id: '11111111-1111-1111-1111-111111111111',
        userId: '11111111-1111-1111-1111-111111111111',
        identityData: {
          'email': 'example@email.com',
          'email_verified': false,
          'phone_verified': false,
          'sub': '11111111-1111-1111-1111-111111111111'
        },
        provider: 'email',
        lastSignInAt: '2024-01-01T00:00:00Z',
        createdAt: '2024-01-01T00:00:00Z',
        updatedAt: '2024-01-01T00:00:00Z',
      )
    ],
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-01T00:00:00Z',
  ),
);

// Caso o email seja alterado o redirecionamento de autenticação preciso ser feito novamente:

final UserResponse res = await supabase.auth.updateUser(
  UserAttributes(
    email: 'example@email.com',
  ),
);
final User? updatedUser = res.user;

// Response redirecionamento do email
UserResponse(
  user: const User(
    id: '11111111-1111-1111-1111-111111111111',
    aud: 'authenticated',
    role: 'authenticated',
    email: 'example@email.com',
    emailConfirmedAt: '2024-01-01T00:00:00Z',
    phone: '',
    lastSignInAt: '2024-01-01T00:00:00Z',
    appMetadata: {
      'provider': 'email',
      'providers': ['email']
    },
    userMetadata: {},
    identities: [
      UserIdentity(
        identityId: '22222222-2222-2222-2222-222222222222',
        id: '11111111-1111-1111-1111-111111111111',
        userId: '11111111-1111-1111-1111-111111111111',
        identityData: {
          'email': 'example@email.com',
          'email_verified': false,
          'phone_verified': false,
          'sub': '11111111-1111-1111-1111-111111111111'
        },
        provider: 'email',
        lastSignInAt: '2024-01-01T00:00:00Z',
        createdAt: '2024-01-01T00:00:00Z',
        updatedAt: '2024-01-01T00:00:00Z',
      )
    ],
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-01T00:00:00Z',
  ),
);


```

