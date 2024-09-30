import 'package:flutter/material.dart';
import 'package:flutter_expensetracker/presentation/components/widget_expense_list_with_filter.dart';
import 'package:flutter_expensetracker/provider/viewmodel_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  final _searchSubject = PublishSubject<String>();

  void _onSearchChanged(String value) {
    _searchSubject.add(value);
  }

  @override
  void initState() {
    super.initState();
    final vm = ref.read(searchViewModelProvider.notifier);

    // Listen to the search input stream with debounce
    _searchSubject
        .debounceTime(const Duration(milliseconds: 500)) // Add 500ms debounce
        .listen((searchTerm) async {
      if (searchTerm.length >= 3) {
        await vm.filterByFullTextSearch(searchTerm);
      } else if (searchTerm.isEmpty) {
        // Clear search results if input is less than 3 characters
        await vm.filterByFullTextSearch("");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: searchController,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
              hintText: "Search expense...",
              hintStyle: TextStyle(color: Colors.black)),
          onChanged: _onSearchChanged,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: WidgetExpenseListWithFilter(
          expensesFilter: searchState,
        ),
      ),
    );
  }
}
