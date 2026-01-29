import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/tlz_search_bar.dart';

/// Search Page - หน้าค้นหาแบบเต็มหน้าจอ
/// รองรับ:
/// - การพิมพ์ค้นหา
/// - ประวัติการค้นหา
/// - คำแนะนำการค้นหา
/// - ผลการค้นหา
class SearchPage extends StatefulWidget {
  /// ข้อความ hint ใน search bar
  final String? hintText;
  
  /// ข้อความค้นหาเริ่มต้น
  final String? initialQuery;
  
  /// หมวดหมู่การค้นหา (เช่น 'all', 'pharmacy', 'doctor')
  final String? category;

  const SearchPage({
    super.key,
    this.hintText,
    this.initialQuery,
    this.category,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  final FocusNode _focusNode = FocusNode();
  
  String _query = '';
  bool _isSearching = false;
  
  // Mock data สำหรับประวัติการค้นหา
  final List<String> _searchHistory = [
    'พาราเซตามอล',
    'ร้านยาใกล้ฉัน',
    'หมอผิวหนัง',
    'วิตามินซี',
  ];
  
  // Mock data สำหรับคำแนะนำ
  final List<Map<String, dynamic>> _suggestions = [
    {'icon': Icons.local_pharmacy, 'title': 'ร้านยา', 'subtitle': 'ค้นหาร้านยาใกล้คุณ'},
    {'icon': Icons.medical_services, 'title': 'ปรึกษาแพทย์', 'subtitle': 'พบแพทย์ออนไลน์'},
    {'icon': Icons.spa, 'title': 'นวดสปา', 'subtitle': 'บริการนวดและสปา'},
    {'icon': Icons.fitness_center, 'title': 'ฟิตเนส', 'subtitle': 'ศูนย์ออกกำลังกาย'},
    {'icon': Icons.vaccines, 'title': 'วัคซีน', 'subtitle': 'บริการฉีดวัคซีน'},
  ];
  
  // Mock data สำหรับผลการค้นหา
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    _query = widget.initialQuery ?? '';
    
    // Auto focus เมื่อเปิดหน้า
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _query = value;
      _isSearching = value.isNotEmpty;
      
      // Mock search results
      if (_isSearching) {
        _searchResults = _generateMockResults(value);
      } else {
        _searchResults = [];
      }
    });
  }

  void _onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      // เพิ่มลงประวัติการค้นหา
      if (!_searchHistory.contains(value)) {
        setState(() {
          _searchHistory.insert(0, value);
          if (_searchHistory.length > 10) {
            _searchHistory.removeLast();
          }
        });
      }
      
      // ทำการค้นหา
      _performSearch(value);
    }
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = true;
      _searchResults = _generateMockResults(query);
    });
  }

  List<Map<String, dynamic>> _generateMockResults(String query) {
    // Mock results based on query
    final lowerQuery = query.toLowerCase();
    
    final allResults = [
      {'type': 'pharmacy', 'icon': Icons.local_pharmacy, 'title': 'ร้านยา เภสัชกรเอก', 'subtitle': 'ห่างจากคุณ 500 เมตร', 'rating': 4.8},
      {'type': 'pharmacy', 'icon': Icons.local_pharmacy, 'title': 'ร้านยา ฟาสซิโน', 'subtitle': 'ห่างจากคุณ 1.2 กม.', 'rating': 4.5},
      {'type': 'doctor', 'icon': Icons.person, 'title': 'นพ.สมชาย ใจดี', 'subtitle': 'อายุรกรรม • พร้อมให้บริการ', 'rating': 4.9},
      {'type': 'medicine', 'icon': Icons.medication, 'title': 'พาราเซตามอล 500mg', 'subtitle': 'ยาแก้ปวด ลดไข้', 'price': '฿35'},
      {'type': 'medicine', 'icon': Icons.medication, 'title': 'วิตามินซี 1000mg', 'subtitle': 'เสริมภูมิคุ้มกัน', 'price': '฿120'},
      {'type': 'clinic', 'icon': Icons.local_hospital, 'title': 'คลินิกหมอสุข', 'subtitle': 'เปิด 09:00-20:00', 'rating': 4.7},
    ];
    
    return allResults
        .where((item) => 
            item['title'].toString().toLowerCase().contains(lowerQuery) ||
            item['subtitle'].toString().toLowerCase().contains(lowerQuery) ||
            item['type'].toString().toLowerCase().contains(lowerQuery))
        .toList();
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _query = '';
      _isSearching = false;
      _searchResults = [];
    });
    _focusNode.requestFocus();
  }

  void _removeFromHistory(String item) {
    setState(() {
      _searchHistory.remove(item);
    });
  }

  void _clearAllHistory() {
    setState(() {
      _searchHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Search Header
            _buildSearchHeader(),
            
            // Content
            Expanded(
              child: _isSearching && _searchResults.isNotEmpty
                  ? _buildSearchResults()
                  : _isSearching && _searchResults.isEmpty
                      ? _buildNoResults()
                      : _buildDefaultContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Search Bar
          Expanded(
            child: TlzSearchBar.onLight(
              hintText: widget.hintText ?? 'ค้นหายา ร้านยา หมอ...',
              controller: _searchController,
              focusNode: _focusNode,
              enabled: true,
              autofocus: true,
              showQRButton: false,
              onChanged: _onSearchChanged,
              onSubmitted: _onSearchSubmitted,
            ),
          ),
          
          // Clear Button (แสดงเมื่อมีข้อความ)
          if (_query.isNotEmpty) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _clearSearch,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.close,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDefaultContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ประวัติการค้นหา
          if (_searchHistory.isNotEmpty) ...[
            _buildSectionHeader(
              'ประวัติการค้นหา',
              onClear: _clearAllHistory,
            ),
            const SizedBox(height: 12),
            _buildSearchHistoryList(),
            const SizedBox(height: 24),
          ],
          
          // คำแนะนำ
          _buildSectionHeader('แนะนำสำหรับคุณ'),
          const SizedBox(height: 12),
          _buildSuggestionsList(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onClear}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.heading5.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        if (onClear != null)
          TextButton(
            onPressed: onClear,
            child: Text(
              'ล้างทั้งหมด',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchHistoryList() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _searchHistory.map((item) {
        return GestureDetector(
          onTap: () {
            _searchController.text = item;
            _onSearchChanged(item);
            _onSearchSubmitted(item);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.history,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  item,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => _removeFromHistory(item),
                  child: Icon(
                    Icons.close,
                    size: 14,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSuggestionsList() {
    return Column(
      children: _suggestions.map((item) {
        return _buildSuggestionItem(
          icon: item['icon'] as IconData,
          title: item['title'] as String,
          subtitle: item['subtitle'] as String,
          onTap: () {
            _searchController.text = item['title'] as String;
            _onSearchChanged(item['title'] as String);
          },
        );
      }).toList(),
    );
  }

  Widget _buildSuggestionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        return _buildResultItem(item);
      },
    );
  }

  Widget _buildResultItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to detail page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('กดเลือก: ${item['title']}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _getTypeColor(item['type'] as String).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item['icon'] as IconData,
                color: _getTypeColor(item['type'] as String),
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] as String,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['subtitle'] as String,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            
            // Rating or Price
            if (item['rating'] != null)
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item['rating'].toString(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            else if (item['price'] != null)
              Text(
                item['price'] as String,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'pharmacy':
        return AppColors.primary;
      case 'doctor':
        return Colors.blue;
      case 'medicine':
        return Colors.orange;
      case 'clinic':
        return Colors.purple;
      default:
        return AppColors.primary;
    }
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          Text(
            'ไม่พบผลการค้นหา',
            style: AppTextStyles.heading5.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ลองค้นหาด้วยคำอื่น',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }
}
