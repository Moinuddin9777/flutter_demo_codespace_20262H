import 'package:flutter/material.dart';

import '../controller/makeup_repository.dart';
import '../model/makeup_product.dart';
import 'makeup_product_card.dart';

class MakeupProductsPage extends StatefulWidget {
  const MakeupProductsPage({super.key, this.repository});

  final MakeupProductDataSource? repository;

  @override
  State<MakeupProductsPage> createState() => _MakeupProductsPageState();
}

class _MakeupProductsPageState extends State<MakeupProductsPage> {
  late final MakeupProductDataSource _repository;
  final ScrollController _scrollController = ScrollController();
  final int _pageSize = 12;

  List<MakeupProduct> _allProducts = [];
  List<MakeupProduct> _visibleProducts = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? MakeupRepository();
    _scrollController.addListener(_onScroll);
    _loadProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _visibleProducts = [];
      _allProducts = [];
      _hasMore = true;
      _isLoadingMore = false;
    });

    try {
      final products = await _repository.fetchProducts();
      if (!mounted) return;
      setState(() {
        _allProducts = products;
        _visibleProducts = products.take(_pageSize).toList();
        _hasMore = products.length > _pageSize;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore || !_hasMore || _allProducts.isEmpty) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    setState(() {
      final nextCount = (_visibleProducts.length + _pageSize).clamp(0, _allProducts.length);
      _visibleProducts = _allProducts.take(nextCount).toList();
      _hasMore = nextCount < _allProducts.length;
      _isLoadingMore = false;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Makeup Products'),
        centerTitle: true,
        backgroundColor: Colors.pink.shade50,
      ),
      body: RefreshIndicator(
        onRefresh: _loadProducts,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Loading products...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 12),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadProducts,
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _visibleProducts.length + (_isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (_isLoadingMore && index == _visibleProducts.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final product = _visibleProducts[index];
        return SizedBox(
          height: 260,
          child: MakeupProductCard(product: product),
        );
      },
    );
  }
}
