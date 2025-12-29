import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool _isPlaying = false;
  bool _showControls = true;
  double _currentPosition = 12.45; // minutes
  final double _totalDuration = 38.10; // minutes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildVideoPlayer(),
            Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildVideoInfo(),
                      _buildQuickQuiz(),
                      _buildChapters(),
                      _buildRelatedVideos(),
                      _buildComments(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls = !_showControls;
        });
      },
      child: Container(
        width: double.infinity,
        height: 250,
        color: Colors.black,
        child: Stack(
          children: [
            // Video thumbnail placeholder
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade900, Colors.green.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.play_circle_outline,
                  size: 80,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),

            // Top controls
            if (_showControls)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.closed_caption, color: Colors.white),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),

            // Center play button
            if (_showControls)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10, color: Colors.white, size: 32),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 56,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPlaying = !_isPlaying;
                        });
                      },
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      icon: const Icon(Icons.forward_10, color: Colors.white, size: 32),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

            // Bottom controls
            if (_showControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                  child: Column(
                    children: [
                      Slider(
                        value: _currentPosition,
                        max: _totalDuration,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white30,
                        onChanged: (value) {
                          setState(() {
                            _currentPosition = value;
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_formatTime(_currentPosition)} / ${_formatTime(_totalDuration)}',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          Row(
                            children: [
                              const Text(
                                '1x',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              const SizedBox(width: 16),
                              IconButton(
                                icon: const Icon(Icons.fullscreen, color: Colors.white),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(double minutes) {
    final mins = minutes.floor();
    final secs = ((minutes - mins) * 60).floor();
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  Widget _buildVideoInfo() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calculus: Differentiation Basics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary,
                child: const Text(
                  'MN',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mr. Ndongo',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'BSc Mathematics, DIPET II',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text('Follow'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.visibility, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '1.2k views',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 8),
              const Text('•', style: TextStyle(color: Colors.grey)),
              const SizedBox(width: 8),
              Icon(Icons.star, size: 16, color: AppColors.secondary),
              const SizedBox(width: 4),
              Text(
                '4.5 (210 ratings)',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('Rate this video'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickQuiz() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.quiz, color: AppColors.info, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Quiz',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Test your knowledge at 18:45',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.info,
              elevation: 0,
            ),
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  Widget _buildChapters() {
    final chapters = [
      {'time': '0:00', 'title': 'Introduction'},
      {'time': '5:30', 'title': 'Product Rule'},
      {'time': '15:12', 'title': 'Quotient Rule'},
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chapters',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...chapters.map((chapter) => _buildChapterItem(
            chapter['time']!,
            chapter['title']!,
          )),
        ],
      ),
    );
  }

  Widget _buildChapterItem(String time, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedVideos() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Related Videos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildRelatedVideoCard(),
          _buildRelatedVideoCard(),
        ],
      ),
    );
  }

  Widget _buildRelatedVideoCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.play_circle_outline, size: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Integration Basics: The Antiderivative',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Mr. Ndongo',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComments() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Comments (12)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              PopupMenuButton(
                child: Row(
                  children: [
                    Text(
                      'Newest',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                  ],
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'newest', child: Text('Newest')),
                  const PopupMenuItem(value: 'top', child: Text('Top Comments')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildCommentItem(),
        ],
      ),
    );
  }

  Widget _buildCommentItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.success,
            child: const Text(
              'AF',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'A. Fotso',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '2 days ago',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Great explanation! The product rule finally makes sense. Thank you, sir.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.thumb_up_outlined, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text('12', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Reply',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildReply(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReply() {
    return Padding(
      padding: const EdgeInsets.only(left: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: const Text(
              'MN',
              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Mr. Ndongo',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '1 day ago',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'You\'re welcome, A. Fotso! Keep practicing.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
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