import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quantifico/app_blocs.dart';
import 'package:quantifico/bloc/auth/barrel.dart';
import 'package:quantifico/bloc/simple_bloc_delegate.dart';
import 'package:quantifico/data/provider/chart_web_provider.dart';
import 'package:quantifico/data/provider/nf_web_provider.dart';
import 'package:quantifico/data/provider/token_local_provider.dart';
import 'package:quantifico/data/repository/auth_repository.dart';
import 'package:quantifico/data/repository/chart_repository.dart';
import 'package:quantifico/data/repository/nf_repository.dart';
import 'package:quantifico/presentation/screen/login_screen.dart';
import 'package:quantifico/presentation/screen/main_screen.dart';
import 'package:quantifico/util/web_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/login_screen/barrel.dart';
import 'data/repository/chart_container_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  const tokenLocalProvider = TokenLocalProvider(storage: FlutterSecureStorage());
  final webClient = WebClient();
  final authRepository = AuthRepository(
    webClient: WebClient(),
    tokenLocalProvider: tokenLocalProvider,
  );
  final chartWebProvider = ChartWebProvider(webClient: webClient);
  final chartRepository = ChartRepository(chartWebProvider: chartWebProvider);
  final sharedPreferences = await SharedPreferences.getInstance();
  final chartContainerRepository = ChartContainerRepository(sharedPreferences: sharedPreferences);
  final nfWebProvider = NfWebProvider(
    webClient: webClient,
    tokenLocalProvider: tokenLocalProvider,
  );
  final nfRepository = NfRepository(nfWebProvider: nfWebProvider);

  runApp(Quantifico(
    authRepository: authRepository,
    chartRepository: chartRepository,
    chartContainerRepository: chartContainerRepository,
    nfRepository: nfRepository,
  ));
}

class Quantifico extends StatelessWidget {
  final AuthRepository authRepository;
  final ChartRepository chartRepository;
  final ChartContainerRepository chartContainerRepository;
  final NfRepository nfRepository;

  const Quantifico({
    this.authRepository,
    this.chartRepository,
    this.chartContainerRepository,
    this.nfRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quantifico',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(authRepository: authRepository)..add(const CheckAuthentication()),
        child: authGuard(),
      ),
    );
  }

  Widget authGuard() {
    return Builder(
      builder: (context) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return AppBlocs(
                authRepository: authRepository,
                chartRepository: chartRepository,
                chartContainerRepository: chartContainerRepository,
                nfRepository: nfRepository,
                child: MainScreen(),
              );
            } else {
              return LoginScreen(
                bloc: LoginScreenBloc(authRepository: authRepository),
              );
            }
          },
        );
      },
    );
  }
}
