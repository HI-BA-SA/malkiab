import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../configs/app.dart';
import '../../../model/tools/entities/AddressEntity/address_entity.dart';
import '../../widgets/address_sheet.dart';
import '../../widgets/design/design.dart';
import 'bloc/address_bloc.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  AddressBloc? _bloc;
  StreamSubscription? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    _bloc?.close();
    super.dispose();
  }

  Future<void> _add() async {
    final entity = await showAddressSheet();
    if (entity != null) _bloc?.add(AddressAddNew(entity));
  }

  Future<void> _edit(AddressEntity address) async {
    final entity = await showAddressSheet(initial: address);
    if (entity != null) {
      _bloc?.add(AddressEdit(
        addressEntity: entity,
        postalCode: address.postalCode,
      ));
    }
  }

  void _remove(AddressEntity address) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Remove address?',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '"${address.addressName}" will be deleted.',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 13.5,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 18),
              GlowButton(
                label: 'Remove',
                gradient: true,
                onPressed: () {
                  Get.back();
                  _bloc?.add(AddressRemove(address.postalCode));
                },
              ),
              TextButton(onPressed: Get.back, child: const Text('Keep it')),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    App.init(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My addresses')),
      body: BlocProvider(
        create: (context) {
          final bloc = AddressBloc();
          _bloc = bloc;
          bloc.add(AddressStart());
          _subscription = bloc.stream.listen((state) {
            if (state is AddressEditedSuccessfully) {
              Get.snackbar(
                'Updated',
                'Your address was saved.',
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(12),
                backgroundColor: scheme.primary,
                colorText: Colors.white,
              );
            }
          });
          return bloc;
        },
        child: BlocBuilder<AddressBloc, AddressState>(
          builder: (context, state) {
            if (state is AddressDefaultScreen) {
              return _AddressList(
                addresses: state.addressList,
                onEdit: _edit,
                onRemove: _remove,
                onAdd: _add,
              );
            }
            if (state is AddressEmpty) {
              return Center(
                child: EmptyState(
                  icon: Icons.location_on_outlined,
                  title: 'No addresses yet',
                  message:
                      'Save where your orders should land — checkout gets easier.',
                  actionLabel: 'Add address',
                  onAction: _add,
                ),
              );
            }
            if (state is AddressError) {
              return Center(
                child: EmptyState(
                  icon: Icons.error_outline_rounded,
                  title: 'Couldn’t load addresses',
                  actionLabel: 'Retry',
                  onAction: () => _bloc?.add(AddressStart()),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        child: GlowButton(
          label: 'Add new address',
          icon: Icons.add_rounded,
          gradient: true,
          onPressed: _add,
        ),
      ),
    );
  }
}

class _AddressList extends StatelessWidget {
  final List<AddressEntity> addresses;
  final ValueChanged<AddressEntity> onEdit;
  final ValueChanged<AddressEntity> onRemove;
  final VoidCallback onAdd;

  const _AddressList({
    required this.addresses,
    required this.onEdit,
    required this.onRemove,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: addresses.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == addresses.length) {
          return OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add another address'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        }

        final a = addresses[index];
        return SoftCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: scheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.location_on_rounded,
                    color: scheme.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            a.addressName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.manrope(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: scheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            a.country,
                            style: GoogleFonts.manrope(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${a.addressDetail}, ${a.state} ${a.postalCode}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        height: 1.45,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => onEdit(a),
                icon: Icon(Icons.edit_outlined,
                    size: 20, color: scheme.onSurfaceVariant),
              ),
              IconButton(
                onPressed: () => onRemove(a),
                icon: Icon(Icons.delete_outline_rounded,
                    size: 20, color: scheme.error),
              ),
            ],
          ),
        );
      },
    );
  }
}
