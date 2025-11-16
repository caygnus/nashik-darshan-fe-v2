import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nashik/features/home/presentation/pages/home_screen.dart';

class OAuthCallbackPage extends StatelessWidget {
  const OAuthCallbackPage({super.key});

  static const routeName = 'OAuthCallbackPage';
  static const routePath = '/oauth-callback';

  @override
  Widget build(BuildContext context) {
    // Get query parameters from the route
    final routeState = GoRouterState.of(context);
    final deepLinkParam = routeState.uri.queryParameters['deep_link'];
    final originalUri = deepLinkParam != null
        ? Uri.parse(deepLinkParam)
        : routeState.uri;
    final queryParams = originalUri.queryParameters;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('OAuth Callback'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.blue, size: 80),
                const SizedBox(height: 24),
                const Text(
                  'OAuth Callback Received!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'If you can see this page, it means OAuth deep linking is working correctly.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                // Display deep link URI
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Deep Link URI:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        originalUri.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                // Display query parameters if any
                if (queryParams.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Query Parameters:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...queryParams.entries.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '${entry.key}: ${entry.value}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    context.goNamed(HomeScreen.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Go to Home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
