import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/services/api/supabase_client.dart';

/// Configure dependencies for remote data.
/// This dependency list uses repositories that connect to Supabase.
List<SingleChildWidget> get providersRemote {
  return [
    // Services
    Provider(
      create: (context) => SupabaseClientService(),
    ) ,
    
    // Repositories
    ChangeNotifierProvider<AuthRepository>(
      create: (context) => SupabaseAuthRepository(
        clientService: context.read(),
      ),
    ),
  ];
}
