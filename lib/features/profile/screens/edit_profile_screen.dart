import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Jean-Pierre Dupont');
  final _bioController = TextEditingController();
  final _locationController = TextEditingController(text: 'Douala, Cameroon');
  String _selectedLanguage = 'Bilingual';
  double _profileCompletion = 0.6;

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCompletionBar(),
            _buildBasicInfo(),
            _buildCredentials(),
            _buildSubjectsExpertise(),
            _buildTeachingStyle(),
            _buildAvailabilityPricing(),
            _buildVerificationTrust(),
            _buildPortfolio(),
            _buildPolicies(),
            const SizedBox(height: 100), // Space for buttons
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.secondary,
        child: const Icon(Icons.visibility, color: Colors.white),
      ),
    );
  }

  Widget _buildCompletionBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile Completion',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${(_profileCompletion * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _profileCompletion,
              backgroundColor: AppColors.inputFill,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return _buildSection(
      title: 'Basic Information',
      isExpanded: true,
      children: [
        _buildCoverImageSection(),
        const SizedBox(height: 20),
        _buildTextField('Full Name', _nameController, 'e.g. Jean-Pierre Dupont'),
        const SizedBox(height: 16),
        _buildBioField(),
        const SizedBox(height: 16),
        _buildTextField('Location', _locationController, 'e.g. Douala, Cameroon'),
        const SizedBox(height: 16),
        _buildLanguageDropdown(),
      ],
    );
  }

  Widget _buildCoverImageSection() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.image,
                  size: 48,
                  color: AppColors.textSecondary.withOpacity(0.3),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.camera_alt, size: 16),
                label: const Text('Change Cover'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.6),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Stack(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
            filled: true,
            fillColor: AppColors.inputFill,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bio',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _bioController,
          maxLines: 4,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: 'Tell students about your teaching passion and experience...',
            hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
            filled: true,
            fillColor: AppColors.inputFill,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
            counterText: '0/500 characters',
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Language',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: _selectedLanguage,
            isExpanded: true,
            underline: const SizedBox(),
            items: ['English', 'French', 'Bilingual']
                .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
    bool isExpanded = false,
    String? emoji,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          tilePadding: const EdgeInsets.all(20),
          childrenPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          title: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (emoji != null) ...[
                const SizedBox(width: 8),
                Text(emoji, style: const TextStyle(fontSize: 18)),
              ],
            ],
          ),
          children: children,
        ),
      ),
    );
  }

  Widget _buildCredentials() {
    return _buildSection(
      title: 'Credentials',
      emoji: '🎓',
      children: [
        Text(
          'Add your qualifications, degrees, and certifications',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSubjectsExpertise() {
    return _buildSection(
      title: 'Subjects & Expertise',
      emoji: '📚',
      children: [
        Text(
          'Select subjects you teach and your expertise level',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildTeachingStyle() {
    return _buildSection(
      title: 'Teaching Style',
      emoji: '🎓',
      children: [
        Text(
          'Describe your teaching methodology and approach',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildAvailabilityPricing() {
    return _buildSection(
      title: 'Availability & Pricing',
      emoji: '💰',
      children: [
        Text(
          'Set your hourly rate and available time slots',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildVerificationTrust() {
    return _buildSection(
      title: 'Verification & Trust',
      emoji: '✅',
      children: [
        Text(
          'Upload ID, certificates, and background check documents',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildPortfolio() {
    return _buildSection(
      title: 'Portfolio',
      emoji: '📸',
      children: [
        Text(
          'Add photos, videos, and work samples',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildPolicies() {
    return _buildSection(
      title: 'Policies',
      emoji: '📋',
      children: [
        Text(
          'Set cancellation policy, refund terms, and house rules',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: BorderSide(color: AppColors.inputBorder),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Preview'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Publish'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}