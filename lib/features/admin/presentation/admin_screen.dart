import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/widgets/decorative_background.dart';
import 'admin_providers.dart';
import 'widgets/login_form.dart';
import 'widgets/pdf_uploader_card.dart';

/// Pantalla de administración — solo accesible con credenciales Firebase.
///
/// Flujo:
///   [No autenticado] → LoginForm
///   [Autenticado]    → Panel con dos tarjetas de subida (ES / EN)
class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const DecorativeBackground(opacity: 0.05),
          authAsync.when(
            loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.darkGreen)),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (isAuth) =>
                isAuth ? const _AdminPanel() : const _LoginView(),
          ),
        ],
      ),
    );
  }
}

// ── Vista de login ────────────────────────────────────────────────────────────

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🌿',
                style: TextStyle(fontSize: 48),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Raíces Restaurante',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.darkGreen,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                'Panel de administración',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.2,
                    ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Panel admin autenticado ───────────────────────────────────────────────────

class _AdminPanel extends ConsumerWidget {
  const _AdminPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.xl,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Header ───────────────────────────────────────────
                Row(
                  children: [
                    const Text('🌿', style: TextStyle(fontSize: 32)),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Panel de menús',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: AppColors.darkGreen,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            'Sube los PDF para actualizar el menú digital',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton.outlined(
                      tooltip: 'Cerrar sesión',
                      icon: const Icon(Icons.logout),
                      onPressed: () =>
                          ref.read(authRepositoryProvider).signOut(),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Instrucciones ─────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.darkGreen.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(Icons.info_outline,
                            size: 16, color: AppColors.darkGreen),
                        SizedBox(width: 6),
                        Text('¿Cómo actualizar el menú?',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkGreen)),
                      ]),
                      SizedBox(height: 6),
                      Text(
                        '1. Selecciona el idioma que deseas actualizar.\n'
                        '2. Haz clic en "Seleccionar PDF" y elige el archivo.\n'
                        '3. El menú se actualiza automáticamente en la app.',
                        style: TextStyle(fontSize: 13, height: 1.6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // ── Tarjetas lado a lado ──────────────────────────────
                const IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: PdfUploaderCard(
                          langCode: 'es',
                          flag: '🇨🇴',
                          label: 'Menú en Español',
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: PdfUploaderCard(
                          langCode: 'en',
                          flag: '🇺🇸',
                          label: 'Menú en Inglés',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
