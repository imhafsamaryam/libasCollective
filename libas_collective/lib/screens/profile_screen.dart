import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/providers/auth_provider.dart';
import 'package:store_app/services/firestore_service.dart';
import 'package:store_app/utils/validators.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _firestoreService = FirestoreService();
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.userData != null) {
      _nameController.text = authProvider.userData?.displayName ?? '';
      _phoneController.text = authProvider.userData?.phoneNumber ?? '';
      _addressController.text = authProvider.userData?.address ?? '';
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      try {
        await _firestoreService.updateUser(authProvider.user!.uid, {
          'displayName': _nameController.text.trim(),
          'phoneNumber': _phoneController.text.trim(),
          'address': _addressController.text.trim(),
        });

        // Refresh user data by calling the public method
        await authProvider.loadUserData(authProvider.user!.uid);

        setState(() {
          _isEditing = false;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                setState(() => _isEditing = false);
                _loadUserData(); // Reset form values
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildProfileHeader(authProvider),
                    const SizedBox(height: 24),
                    _buildFormFields(),
                    if (_isEditing) _buildSaveButton(),
                    const SizedBox(height: 24),
                    _buildSignOutButton(authProvider),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileHeader(AuthProvider authProvider) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: authProvider.userData?.photoUrl != null
              ? NetworkImage(authProvider.userData!.photoUrl!)
              : null,
          child: authProvider.userData?.photoUrl == null
              ? const Icon(Icons.person, size: 50)
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          authProvider.userData?.displayName ?? 'No Name',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          authProvider.userData?.email ?? '',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          enabled: _isEditing,
          validator: Validators.validateName,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
          enabled: _isEditing,
          keyboardType: TextInputType.phone,
          validator: Validators.validatePhone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          enabled: _isEditing,
          maxLines: 3,
          validator: Validators.validateAddress,
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton(
        onPressed: _updateProfile,
        child: const Text('Save Changes'),
      ),
    );
  }

  Widget _buildSignOutButton(AuthProvider authProvider) {
    return ElevatedButton(
      onPressed: () async {
        await authProvider.signOut();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      child: const Text('Sign Out'),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
