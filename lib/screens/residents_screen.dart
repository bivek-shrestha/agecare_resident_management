import 'package:flutter/material.dart';

import '../models/resident.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/resident_card.dart';
import 'resident_detail_screen.dart';

enum ResidentFilter { all, priority, newAdmission, discharge }

class ResidentsScreen extends StatefulWidget {
  final AppState appState;
  final String initialSearchQuery;
  final ResidentFilter initialFilter;
  final int searchRequestId;

  const ResidentsScreen({
    super.key,
    required this.appState,
    this.initialSearchQuery = '',
    this.initialFilter = ResidentFilter.all,
    this.searchRequestId = 0,
  });

  @override
  State<ResidentsScreen> createState() => _ResidentsScreenState();
}

class _ResidentsScreenState extends State<ResidentsScreen> {
  late final TextEditingController _searchController;
  late String _query;
  ResidentFilter _filter = ResidentFilter.all;

  @override
  void initState() {
    super.initState();
    _query = widget.initialSearchQuery;
    _filter = widget.initialFilter;
    _searchController = TextEditingController(text: widget.initialSearchQuery);
  }

  @override
  void didUpdateWidget(covariant ResidentsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.searchRequestId != oldWidget.searchRequestId) {
      _query = widget.initialSearchQuery;
      _searchController.text = widget.initialSearchQuery;
      _searchController.selection = TextSelection.collapsed(
        offset: _searchController.text.length,
      );
      _filter = widget.initialFilter;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Resident> _filtered(List<Resident> residents) {
    return residents.where((resident) {
      final text = _query.toLowerCase().trim();
      final matchesQuery = text.isEmpty ||
          resident.name.toLowerCase().contains(text) ||
          resident.room.toLowerCase().contains(text) ||
          resident.id.toLowerCase().contains(text) ||
          resident.careLevel.toLowerCase().contains(text) ||
          resident.doctor.toLowerCase().contains(text);

      final matchesFilter = switch (_filter) {
        ResidentFilter.all => true,
        ResidentFilter.priority => resident.status == ResidentStatus.high,
        ResidentFilter.newAdmission => resident.isNewAdmission,
        ResidentFilter.discharge => resident.dischargePlanned,
      };

      return matchesQuery && matchesFilter;
    }).toList();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() => _query = '');
  }

  void _clearAll() {
    _searchController.clear();
    setState(() {
      _query = '';
      _filter = ResidentFilter.all;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.appState,
      builder: (context, _) {
        final residents = _filtered(widget.appState.residents);
        final hasFilters = _query.isNotEmpty || _filter != ResidentFilter.all;

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Residents',
                style: TextStyle(
                  fontSize: 25,
                  height: 1.1,
                  letterSpacing: -0.4,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: 'Search residents',
                  prefixIcon: const Icon(Icons.search_rounded, size: 21),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear',
                          onPressed: _clearSearch,
                          icon: const Icon(Icons.close_rounded, size: 20),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _FilterChip(
                      label: 'All',
                      selected: _filter == ResidentFilter.all,
                      onTap: () => setState(() => _filter = ResidentFilter.all),
                    ),
                    _FilterChip(
                      label: 'High',
                      selected: _filter == ResidentFilter.priority,
                      onTap: () => setState(() => _filter = ResidentFilter.priority),
                    ),
                    _FilterChip(
                      label: 'New',
                      selected: _filter == ResidentFilter.newAdmission,
                      onTap: () => setState(() => _filter = ResidentFilter.newAdmission),
                    ),
                    _FilterChip(
                      label: 'Leaving',
                      selected: _filter == ResidentFilter.discharge,
                      onTap: () => setState(() => _filter = ResidentFilter.discharge),
                    ),
                    if (hasFilters)
                      Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: TextButton(
                          onPressed: _clearAll,
                          style: TextButton.styleFrom(
                            minimumSize: const Size(48, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          child: const Text(
                            'Clear',
                            style: TextStyle(fontSize: 11.5),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: residents.isEmpty
                    ? _EmptyResidents(onClear: _clearAll)
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth >= 760) {
                            return GridView.builder(
                              padding: const EdgeInsets.only(bottom: 22),
                              itemCount: residents.length,
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 520,
                                mainAxisExtent: 94,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemBuilder: (context, index) {
                                final resident = residents[index];
                                return ResidentCard(
                                  resident: resident,
                                  onTap: () => _openResident(resident),
                                );
                              },
                            );
                          }

                          return ListView.separated(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: residents.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final resident = residents[index];
                              return ResidentCard(
                                resident: resident,
                                onTap: () => _openResident(resident),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openResident(Resident resident) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResidentDetailScreen(appState: widget.appState, resident: resident),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        selectedColor: AppColors.primary.withOpacity(0.10),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        labelStyle: TextStyle(
          color: selected ? AppColors.primaryDark : AppColors.textSecondary,
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
        ),
        side: BorderSide(
          color: selected
              ? AppColors.primary.withOpacity(0.20)
              : const Color(0xFFE7EDF4),
        ),
      ),
    );
  }
}

class _EmptyResidents extends StatelessWidget {
  final VoidCallback onClear;

  const _EmptyResidents({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.07),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_search_rounded,
              size: 30,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'No matches',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onClear,
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
