      actions: [
        IconButton(
          icon: const Icon(LucideIcons.bell_ring, size: 22),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        if (kDebugMode)
          IconButton(
            icon: const Icon(LucideIcons.bug, size: 22),
            tooltip: 'Test Sentry',
            onPressed: () {
              throw StateError('This is a test exception for Sentry verification');
            },
          ),
      ],