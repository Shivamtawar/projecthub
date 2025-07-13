import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdSubmissionScreen extends StatefulWidget {
  const AdSubmissionScreen({super.key});

  @override
  State createState() => _AdSubmissionScreenState();
}

class _AdSubmissionScreenState extends State<AdSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _websiteController = TextEditingController();

  // Form fields
  String? _selectedTemplate;
  DateTime? _startDate;
  DateTime? _endDate;
  List<String>? _selectedLocations = [];
  List<String> _selectedCategories = [];
  String? _adTitle;
  String? _adDescription;
  File? _bannerImage;
  bool _showPreview = false;

  // Impression fields
  double _impressions = 1; // in thousands
  double? _calculatedCost;
  bool _isCalculating = false;

  // Mock data
  final List<String> _templates = ['In app Template', 'Personal Brand'];
  final List<String> _locations = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Miami'
  ];
  final List<String> _categories = [
    'Business',
    'Education',
    'Health',
    'Food',
    'Technology'
  ];

  // Pricing model (example: cost per thousand impressions)
  final double _costPerThousand = 0.5; // \$0.5 per 1000 impressions

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Advertisement'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Show help dialog
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_showPreview) ...[
                // Template Selection
                _buildSectionHeader('1. Select What you want to promote'),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Template to Promote',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedTemplate,
                  items: _templates.map((template) {
                    return DropdownMenuItem(
                      value: template,
                      child: Text(template),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTemplate = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a template' : null,
                ),
                const SizedBox(height: 20),

                // Ad Details
                _buildSectionHeader('2. Ad Details'),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Ad Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please enter an ad title'
                      : null,
                  onSaved: (value) => _adTitle = value,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Website URL',
                      border: OutlineInputBorder(),
                      hintText: 'https://example.com',
                      prefixIcon: Icon(Icons.link)),
                  controller: _websiteController,
                  keyboardType: TextInputType.url,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a website URL';
                    }
                    if (!Uri.tryParse(value)!.hasAbsolutePath) {
                      return 'Please enter a valid URL';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Ad Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter an ad description' : null,
                  onSaved: (value) => _adDescription = value,
                ),
                const SizedBox(height: 20),

                // Banner Image
                _buildSectionHeader('3. Banner Image'),
                _buildImageUploadField(),
                const SizedBox(height: 20),

                // Date Range
                _buildSectionHeader('4. Schedule'),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, isStartDate: true),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Start Date',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _startDate != null
                                ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                                : 'Select start date',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context, isStartDate: false),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'End Date',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _endDate != null
                                ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                                : 'Select end date',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Location Targeting
                // Add these imports at the top if not already present

// ... (keep all your existing code until the MultiSelectDialogField widgets)

// Replace the Location Targeting section with this:
                _buildSectionHeader('5. Target Locations'),
                MultiSelectDialogField<String>(
                  items: _locations
                      .map((location) => MultiSelectItem(location, location))
                      .toList(),
                  title: const Text("Select Locations"),
                  selectedColor: Theme.of(context).primaryColor,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  buttonIcon: const Icon(Icons.location_on),
                  buttonText: const Text("Choose target locations"),
                  onConfirm: (results) {
                    _selectedLocations = results.cast<String>();
                  },
                  initialValue: _selectedLocations!,
                  searchable: true,
                  searchHint: "Search locations...",
                  itemsTextStyle: const TextStyle(fontSize: 16),
                  chipDisplay: MultiSelectChipDisplay(
                    textStyle: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                const SizedBox(height: 20),

// Replace the Categories section with this:
                _buildSectionHeader('6. Target Categories'),
                MultiSelectDialogField<String>(
                  items: _categories
                      .map((category) => MultiSelectItem(category, category))
                      .toList(),
                  title: const Text("Select Categories"),
                  selectedColor: Theme.of(context).primaryColor,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  buttonIcon: const Icon(Icons.category),
                  buttonText: const Text("Choose target categories"),
                  onConfirm: (results) {
                    _selectedCategories = results.cast<String>();
                  },
                  initialValue: _selectedCategories,
                  searchable: true,
                  searchHint: "Search categories...",
                  itemsTextStyle: const TextStyle(fontSize: 16),
                  chipDisplay: MultiSelectChipDisplay(
                    textStyle: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                const SizedBox(height: 20),
                // Impressions and Cost
                _buildSectionHeader('7. Impressions & Cost'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Impressions: ${_impressions.toInt()}K',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Slider(
                      value: _impressions,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: '${_impressions.toInt()}K',
                      onChanged: (value) {
                        setState(() {
                          _impressions = value;
                          _calculatedCost =
                              null; // Reset cost when impressions change
                        });
                      },
                    ),
                    Row(
                      children: [
                        Text(
                          '1K',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const Spacer(),
                        Text(
                          '100K',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (_calculatedCost != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'Estimated Cost: \$${_calculatedCost!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            '(\$$_costPerThousand per 1000 impressions)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: _isCalculating
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2,
                              )
                            : const Icon(Icons.calculate),
                        label: Text(_calculatedCost == null
                            ? 'CALCULATE COST'
                            : 'UPDATE CALCULATION'),
                        onPressed: _calculateCost,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Preview and Submit Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: _validateAndPreview,
                        child: const Text(
                          'PREVIEW AD',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: _calculatedCost == null ? null : _submitAd,
                        child: const Text(
                          'SUBMIT',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ] else ...[
                // Preview Section
                _buildSectionHeader('Ad Preview'),
                _buildAdPreview(),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                    ),
                    onPressed: () {
                      setState(() {
                        _showPreview = false;
                      });
                    },
                    child: const Text(
                      'BACK TO EDIT',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_bannerImage != null)
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Image.file(_bannerImage!, fit: BoxFit.cover),
          )
        else
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 40, color: Colors.grey),
                  Text('No banner image selected'),
                ],
              ),
            ),
          ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.photo_library),
                label: const Text('Gallery'),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Camera'),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
            ),
          ],
        ),
        if (_bannerImage == null)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Please upload a banner image (recommended size: 1200x600)',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _bannerImage = File(pickedFile.path);
      });
    }
  }

  Widget _buildAdPreview() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_bannerImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _bannerImage!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 180,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.image, size: 60, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              _adTitle ?? '[Ad Title]',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _adDescription ?? '[Ad Description]',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (_websiteController.text.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.link, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    _websiteController.text,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Impressions: ${_impressions.toInt()}K',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (_calculatedCost != null)
                  Text(
                    'Cost: \$${_calculatedCost!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (_startDate != null && _endDate != null)
              Text(
                '${DateFormat('MMM d').format(_startDate!)} - ${DateFormat('MMM d, y').format(_endDate!)}',
                style: const TextStyle(color: Colors.grey),
              ),
            const SizedBox(height: 8),
            if (_selectedLocations!.isNotEmpty)
              Wrap(
                spacing: 4,
                children: [
                  const Icon(Icons.location_on, size: 16),
                  Text('Targeting: ${_selectedLocations!.join(', ')}'),
                ],
              ),
            if (_selectedCategories.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Wrap(
                  spacing: 4,
                  children: [
                    const Icon(Icons.category, size: 16),
                    Text('Categories: ${_selectedCategories.join(', ')}'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, {bool? isStartDate}) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      currentDate: isStartDate!
          ? DateTime.now()
          : DateTime.now().add(const Duration(days: 7)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate!.add(const Duration(days: 1));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _calculateCost() {
    setState(() {
      _isCalculating = true;
    });

    // Simulate a calculation delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _calculatedCost = _impressions * _costPerThousand;
        _isCalculating = false;
      });
    });
  }

  void _validateAndPreview() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_calculatedCost == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please calculate the cost first')),
        );
        return;
      }
      setState(() {
        _showPreview = true;
      });
    }
  }

  void _submitAd() {
    if (_formKey.currentState!.validate() && _calculatedCost != null) {
      _formKey.currentState!.save();

      if (_bannerImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload a banner image')),
        );
        return;
      }

      // Here you would typically send the data to your backend
      final adData = {
        'template': _selectedTemplate,
        'title': _adTitle,
        'description': _adDescription,
        'website': _websiteController.text,
        'startDate': _startDate,
        'endDate': _endDate,
        'locations': _selectedLocations,
        'categories': _selectedCategories,
        'impressions': _impressions,
        'cost': _calculatedCost,
        'hasImage': _bannerImage != null,
      };

      print('Submitting ad: $adData');

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Ad Submission'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('You are about to submit an ad with:'),
              const SizedBox(height: 10),
              Text('Impressions: ${_impressions.toInt()}K'),
              Text('Cost: \$${_calculatedCost!.toStringAsFixed(2)}'),
              Text(
                  'Duration: ${_endDate!.difference(_startDate!).inDays} days'),
              Text('Website: ${_websiteController.text}'),
              Text('Locations: ${_selectedLocations!.join(', ')}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showPaymentScreen();
              },
              child: const Text('CONFIRM'),
            ),
          ],
        ),
      );
    }
  }

  void _showPaymentScreen() {
    // Navigate to payment screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Payment')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.payment, size: 80, color: Colors.green),
                const SizedBox(height: 20),
                const Text('Proceed to Payment',
                    style: TextStyle(fontSize: 20)),
                const SizedBox(height: 30),
                Text('\$${_calculatedCost!.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold)),
                Text(
                  'for ${_impressions.toInt()}K impressions',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    // Process payment
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Advertisement submitted successfully!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: const Text('PAY NOW'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
