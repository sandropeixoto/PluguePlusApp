import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/category.dart';

class SearchCard extends StatelessWidget {
  const SearchCard({
    super.key,
    required this.cityController,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSearch,
    required this.onCategoryChanged,
  });

  final TextEditingController cityController;
  final List<Category> categories;
  final int? selectedCategoryId;
  final VoidCallback onSearch;
  final ValueChanged<int?> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Buscar Servicos e Pontos de Recarga',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: const Color(0xFF0F3B2E),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      labelText: 'Cidade',
                      prefixIcon: Icon(Icons.location_on_outlined),
                      filled: true,
                      fillColor: Color(0xFFF6F9F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => onSearch(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int?>(
                    value: selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Categoria',
                      filled: true,
                      fillColor: Color(0xFFF6F9F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: [
                      const DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Todas as categorias'),
                      ),
                      ...categories.map(
                        (c) => DropdownMenuItem<int?>(
                          value: c.id,
                          child: Text(c.name),
                        ),
                      ),
                    ],
                    onChanged: onCategoryChanged,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F8F5F),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onSearch,
                  child: const Text('Buscar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
