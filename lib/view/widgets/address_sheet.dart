import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../configs/app.dart';
import 'design/design.dart';
import '../../model/tools/entities/AddressEntity/address_entity.dart';

const addressCountries = [
  'United States',
  'United Kingdom',
  'France',
  'Italy',
  'Spain',
  'Germany',
  'United Arab Emirates',
  'Egypt',
  'Morocco',
  'Canada',
];

/// Shows the add/edit address sheet.
/// Returns the created/updated [AddressEntity], or null if cancelled.
Future<AddressEntity?> showAddressSheet({AddressEntity? initial}) {
  return Get.bottomSheet<AddressEntity>(
    _AddressSheet(initial: initial),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}

class _AddressSheet extends StatefulWidget {
  final AddressEntity? initial;
  const _AddressSheet({this.initial});

  @override
  State<_AddressSheet> createState() => _AddressSheetState();
}

class _AddressSheetState extends State<_AddressSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name =
      TextEditingController(text: widget.initial?.addressName ?? '');
  late final TextEditingController _street =
      TextEditingController(text: widget.initial?.addressDetail ?? '');
  late final TextEditingController _state =
      TextEditingController(text: widget.initial?.state ?? '');
  late final TextEditingController _postal =
      TextEditingController(
          text: widget.initial == null ? '' : '${widget.initial!.postalCode}');
  late String _country = widget.initial?.country ?? addressCountries.first;

  @override
  void dispose() {
    _name.dispose();
    _street.dispose();
    _state.dispose();
    _postal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final scheme = Theme.of(context).colorScheme;
    final isEdit = widget.initial != null;

    return Container(
      constraints: BoxConstraints(
        maxHeight: Get.mediaQuery.size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 22,
            right: 22,
            bottom: MediaQuery.of(context).viewInsets.bottom + 22,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18),
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: scheme.outlineVariant,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  isEdit ? 'Edit address' : 'New address',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                _field(
                  controller: _name,
                  label: 'Address name',
                  hint: 'Home, Office…',
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                _field(
                  controller: _street,
                  label: 'Street address',
                  hint: '12 Rosewood Ave, Apt 4',
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _field(
                        controller: _state,
                        label: 'State / City',
                        hint: 'Paris',
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Required'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _field(
                        controller: _postal,
                        label: 'Postal code',
                        hint: '75001',
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            (v == null || int.tryParse(v.trim()) == null)
                                ? 'Digits only'
                                : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Country',
                  style: GoogleFonts.manrope(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: addressCountries.contains(_country)
                      ? _country
                      : addressCountries.first,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  items: [
                    for (final c in addressCountries)
                      DropdownMenuItem(value: c, child: Text(c)),
                  ],
                  onChanged: (v) => setState(() => _country = v ?? _country),
                ),
                const SizedBox(height: 22),
                GlowButton(
                  label: isEdit ? 'Save changes' : 'Save address',
                  gradient: true,
                  onPressed: () {
                    if (!(_formKey.currentState?.validate() ?? false)) {
                      return;
                    }
                    Get.back(
                      result: AddressEntity(
                        addressName: _name.text.trim(),
                        country: _country,
                        state: _state.text.trim(),
                        addressDetail: _street.text.trim(),
                        postalCode: int.parse(_postal.text.trim()),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              isDense: true,
              hintText: hint,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
