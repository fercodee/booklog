import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/auth/auth_repository.dart';
import '../data/repositories/auth/auth_repository_impl.dart';
import '../data/repositories/book/book_repository.dart';
import '../data/repositories/book/book_repository_impl.dart';
import '../data/services/api/supabase_client.dart';
import '../ui/home/home_view_model.dart';

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
    Provider<BookRepository>(
      create: (context) => SupabaseBookRepository(
        clientService: context.read(),
      ),
    ),

    // ViewModels
    ChangeNotifierProvider<HomeViewModel>(
      create: (context) => HomeViewModel(
        repository: context.read(),
      ),
    ),
  ];
}
