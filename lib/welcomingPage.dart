import 'package:flutter/material.dart';
// If you want Skip to log in as guest immediately, uncomment the next line
// import '../fake_auth.dart';  // and call fakeAuth.loginAsGuest() below

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 253, 254),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Top image with soft corners + gradient overlay
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            'assets/images/R.jpeg',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const ColoredBox(
                              color: Colors.black12,
                              child: Center(child: Icon(Icons.image_not_supported_outlined, size: 48)),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black26],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 16,
                            right: 16,
                            bottom: 16,
                            child: Text(
                              'Welcome to MindShelf',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                 
                  const SizedBox(height: 24),

                  // Buttons
                  if (isWide)
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () {
                              // Go to role chooser (Writer / Reader)
                              Navigator.pushNamed(context, '/role');
                            },
                            child: const Text('Register'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text('Log in'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              // Optional: log in as guest before navigating
                              // await fakeAuth.loginAsGuest();
                              Navigator.pushReplacementNamed(context, '/prefs');
                            },
                            child: const Text('Skip for now'),
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FilledButton(
                          onPressed: () => Navigator.pushNamed(context, '/role'),
                          child: const Text('Register'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () => Navigator.pushNamed(context, '/login'),
                          child: const Text('Log in'),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () async {
                            // Optional: log in as guest before navigating
                            // await fakeAuth.loginAsGuest();
                            Navigator.pushReplacementNamed(context, '/prefs');
                          },
                          child: const Text('Skip for now'),
                        ),
                      ],
                    ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
