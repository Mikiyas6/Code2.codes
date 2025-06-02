import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final Map<String, dynamic> chosenCard;
  const Home({super.key, required this.chosenCard});

  @override
  Widget build(BuildContext context) {
    // Theme based on card
    final LinearGradient gradient = chosenCard['gradient'];
    final String title = chosenCard['title'];
    final String desc = chosenCard['desc'];
    final List icons = chosenCard['icons'];

    // Personalized greeting
    String greeting;
    String actionText;
    String subtitle;
    Widget actionWidget;

    if (title.contains('Dream Job')) {
      greeting = "Welcome, Future Innovator!";
      subtitle = "Let's get you ready for your dream company interviews.";
      actionText = "Start Your MAANG Prep";
      actionWidget = _buildCompanyPath(icons);
    } else if (title.contains('Question Guided')) {
      greeting = "Welcome, Problem Solver!";
      subtitle = "Let's tackle your first question and build momentum.";
      actionText = "Solve Your First Challenge";
      actionWidget = _buildQuestionPath();
    } else if (title.contains('Foundational')) {
      greeting = "Welcome, DSA Explorer!";
      subtitle =
          "Let's build a rock-solid foundation in Data Structures & Algorithms.";
      actionText = "Begin Your Foundation";
      actionWidget = _buildFoundationPath();
    } else {
      greeting = "Welcome!";
      subtitle = "Let's start your personalized journey.";
      actionText = "Get Started";
      actionWidget = const SizedBox();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Themed header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 36,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: const TextStyle(
                        fontFamily: 'Jost',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Show icons
                    Row(
                      children: icons
                          .map<Widget>(
                            (icon) => Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Image.asset(icon, width: 40, height: 40),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Card summary
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Jost',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0961F5),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          desc,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Personalized action section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildRoadmap(title, icons),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF60A5FA),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 3,
                      ),
                      icon: const Icon(
                        Icons.rocket_launch,
                        color: Colors.white,
                      ),
                      label: Text(
                        actionText,
                        style: const TextStyle(
                          fontFamily: 'Jost',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        // TODO: Navigate to the next personalized step
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Let\'s go! 🚀')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              // Motivational quote
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  _getMotivationalQuote(title),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  // Example: Company path widget
  Widget _buildCompanyPath(List icons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Your Target Companies:",
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: icons
              .map<Widget>(
                (icon) => Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Image.asset(icon, width: 32, height: 32),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 18),
        const Text(
          "Curated DSA topics and interview questions will be unlocked for your chosen companies.",
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Example: Question path widget
  Widget _buildQuestionPath() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Today's Challenge:",
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "• Solve 1 Easy Linked List Question\n• Estimated Time: 5 mins",
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Example: Foundation path widget
  Widget _buildFoundationPath() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Start Here:",
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "• Learn the basics of Arrays, Strings, and Linked Lists\n• Interactive lessons and quizzes await!",
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  String _getMotivationalQuote(String title) {
    if (title.contains('Dream Job')) {
      return "“Opportunities don't happen. You create them.”\n— Chris Grosser";
    } else if (title.contains('Question Guided')) {
      return "“The secret of getting ahead is getting started.”\n— Mark Twain";
    } else if (title.contains('Foundational')) {
      return "“Success is the sum of small efforts, repeated day in and day out.”\n— Robert Collier";
    }
    return "“Your journey to mastery starts with a single step.”";
  }

  // Add this method to your Home class:
  Widget _buildRoadmap(String title, List icons) {
    if (title.contains('Dream Job')) {
      // MAANG/Company Prep Roadmap
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Dream Job Roadmap",
            style: TextStyle(
              fontFamily: 'Jost',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 18),
          _roadmapStep(
            "Step 1: Master Core DSA",
            "Arrays, Strings, Linked Lists, Trees, Graphs",
          ),
          _roadmapStep(
            "Step 2: Ace System Design",
            "Learn scalable architectures & patterns",
          ),
          _roadmapStep(
            "Step 3: Company-Specific Questions",
            "Practice real MAANG interview problems",
          ),
          _roadmapStep(
            "Step 4: Mock Interviews",
            "Sharpen your skills with timed practice",
          ),
          const SizedBox(height: 18),
          Row(
            children: icons
                .map<Widget>(
                  (icon) => Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Image.asset(icon, width: 32, height: 32),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          const LinearProgressIndicator(
            value: 0.2,
            backgroundColor: Color(0xFFE3F0FF),
            color: Color(0xFF60A5FA),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          const Text(
            "You're at the start of your journey. Let's make it legendary!",
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      );
    } else if (title.contains('Question Guided')) {
      // Question Guided Roadmap
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Guided Practice Roadmap",
            style: TextStyle(
              fontFamily: 'Jost',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 18),
          _roadmapStep(
            "Step 1: Daily Challenge",
            "Solve a new problem every day",
          ),
          _roadmapStep(
            "Step 2: Review & Reflect",
            "Analyze your solutions and learn from mistakes",
          ),
          _roadmapStep(
            "Step 3: Level Up",
            "Unlock harder problems as you progress",
          ),
          const SizedBox(height: 18),
          const LinearProgressIndicator(
            value: 0.35,
            backgroundColor: Color(0xFFE3F0FF),
            color: Color(0xFF60A5FA),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          const Text(
            "Consistency is key. Keep your streak alive!",
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      );
    } else if (title.contains('Foundational')) {
      // Foundational Roadmap
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your DSA Foundation Roadmap",
            style: TextStyle(
              fontFamily: 'Jost',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 18),
          _roadmapStep(
            "Step 1: Learn Arrays & Strings",
            "Interactive lessons and quizzes",
          ),
          _roadmapStep(
            "Step 2: Practice Linked Lists",
            "Visualize and solve basic problems",
          ),
          _roadmapStep(
            "Step 3: Explore Stacks & Queues",
            "Understand real-world applications",
          ),
          _roadmapStep(
            "Step 4: Weekly Recap",
            "Test your knowledge and track progress",
          ),
          const SizedBox(height: 18),
          const LinearProgressIndicator(
            value: 0.1,
            backgroundColor: Color(0xFFE3F0FF),
            color: Color(0xFF60A5FA),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          const Text(
            "Every expert was once a beginner. Start strong!",
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      );
    }
    // Default fallback
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Your Personalized Roadmap",
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 18),
        _roadmapStep("Step 1: Explore", "Discover your learning path"),
        _roadmapStep("Step 2: Practice", "Sharpen your skills"),
        _roadmapStep("Step 3: Achieve", "Reach your goals"),
        const SizedBox(height: 18),
        const LinearProgressIndicator(
          value: 0.05,
          backgroundColor: Color(0xFFE3F0FF),
          color: Color(0xFF60A5FA),
          minHeight: 8,
        ),
        const SizedBox(height: 8),
        const Text(
          "Let's begin your journey!",
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Helper for roadmap steps
  Widget _roadmapStep(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Color(0xFF60A5FA),
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
