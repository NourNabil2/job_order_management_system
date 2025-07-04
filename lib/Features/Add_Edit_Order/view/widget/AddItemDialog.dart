import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Widgets/Custom_dropMenu.dart';
import 'package:quality_management_system/Features/OrderTableDetails/model/data/OrderItem_model.dart';

class AddItemDialog extends StatefulWidget {
  final Function(List<OrderItem>) onItemsUpdated;
  final List<OrderItem> initialItems;
  final String dialogTitle;

  const AddItemDialog({
    Key? key,
    required this.onItemsUpdated,
    this.initialItems = const [],
    this.dialogTitle = 'إدارة البنود',
  }) : super(key: key);

  @override
  _AddItemDialog createState() => _AddItemDialog();
}

class _AddItemDialog extends State<AddItemDialog>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _materialTypeController = TextEditingController();
  final _notesController = TextEditingController();
  final _statusController = TextEditingController();
  final _unitPriceController = TextEditingController();

  late TabController _tabController;
  late List<OrderItem> _items;
  int? _editingIndex;
  bool _isEditing = false;

  final List<String> _statusOptions = ['Pending', 'In_Progress', 'Complete', 'Rejected'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _items = List<OrderItem>.from(widget.initialItems);
    _clearForm();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _materialTypeController.dispose();
    _notesController.dispose();
    _statusController.dispose();
    _unitPriceController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _descriptionController.clear();
    _quantityController.clear();
    _materialTypeController.clear();
    _notesController.clear();
    _statusController.text = 'Pending';
    _unitPriceController.clear();
    _editingIndex = null;
    _isEditing = false;
  }

  void _loadItemForEditing(OrderItem item, int index) {
    setState(() {
      _descriptionController.text = item.operationDescription;
      _quantityController.text = item.quantity.toString();
      _materialTypeController.text = item.materialType ?? '';
      _notesController.text = item.notes ?? '';
      _statusController.text = item.status ?? 'Pending';
      _unitPriceController.text = item.unitPrice?.toString() ?? '';
      _editingIndex = index;
      _isEditing = true;
    });
    _tabController.animateTo(0);
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final newItem = OrderItem(
        id: _isEditing
            ? _items[_editingIndex!].id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        operationDescription: _descriptionController.text,
        status: _statusController.text,
        quantity: int.parse(_quantityController.text),
        materialType: _materialTypeController.text,
        notes: _notesController.text,
        unitPrice: double.tryParse(_unitPriceController.text) ?? 0.0,
      );

      setState(() {
        if (_isEditing) {
          _items[_editingIndex!] = newItem;
        } else {
          _items.add(newItem);
        }
      });

      _clearForm();
      _showSuccessSnackBar(_isEditing ? 'تم تحديث البند بنجاح' : 'تم إضافة البند بنجاح');

      // Switch to items list tab
      _tabController.animateTo(1);
    }
  }

  void _deleteItem(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange[700]),
            const SizedBox(width: 8),
            const Text('تأكيد الحذف'),
          ],
        ),
        content: Text(
          'هل أنت متأكد من حذف "${_items[index].operationDescription}"؟',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _items.removeAt(index);
              });
              Navigator.of(context).pop();
              _showSuccessSnackBar('تم حذف البند بنجاح');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(child: _buildTabBarView()),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[600]!, Colors.blue[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.inventory_2, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.dialogTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'إجمالي البنود: ${_items.length}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.blue[600],
        ),
        tabs: [
          Tab(
            icon: Icon(Icons.add_circle_outline),
            text: _isEditing ? 'تعديل البند' : 'إضافة بند',
          ),
          Tab(
            icon: Icon(Icons.list_alt),
            text: 'قائمة البنود',
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildAddEditForm(),
        _buildItemsList(),
      ],
    );
  }

  Widget _buildAddEditForm() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildFormField(
              controller: _descriptionController,
              label: 'بيان العملية',
              icon: Icons.description,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يجب إدخال بيان العملية';
                }
                return null;
              },
            ),
            _buildFormField(
              controller: _quantityController,
              label: 'الكمية',
              icon: Icons.numbers,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يجب إدخال الكمية';
                }
                if (int.tryParse(value) == null) {
                  return 'يجب إدخال رقم صحيح';
                }
                return null;
              },
            ),
            _buildFormField(
              controller: _materialTypeController,
              label: 'نوع الخامة',
              icon: Icons.category,
            ),
            _buildFormField(
              controller: _unitPriceController,
              label: 'سعر الوحدة',
              icon: Icons.monetization_on,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            CustomDropMenu(
              label: 'حالة التسليم',
              value: _statusOptions.contains(_statusController.text)
                  ? _statusController.text
                  : 'Pending',
              options: _statusOptions,
              onChanged: (val) => _statusController.text = val ?? 'Pending',
            ),
            const SizedBox(height: 16),
            _buildFormField(
              controller: _notesController,
              label: 'ملاحظات',
              icon: Icons.notes,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveItem,
                icon: Icon(_isEditing ? Icons.update : Icons.add),
                label: Text(_isEditing ? 'تحديث البند' : 'إضافة البند'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            if (_isEditing) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: _clearForm,
                  icon: const Icon(Icons.clear),
                  label: const Text('إلغاء التعديل'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد بنود',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'اضغط على تبويب "إضافة بند" لإضافة أول بند',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: Colors.blue[600],
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                item.operationDescription,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.numbers, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text('الكمية: ${item.quantity}'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text('الحالة: ${item.status}'),
                    ],
                  ),
                  if (item.materialType != null && item.materialType!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.category, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text('الخامة: ${item.materialType}'),
                      ],
                    ),
                  ],
                  if (item.unitPrice != null && item.unitPrice! > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.monetization_on, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text('السعر: ${item.unitPrice}'),
                      ],
                    ),
                  ],
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _loadItemForEditing(item, index),
                    tooltip: 'تعديل',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteItem(index),
                    tooltip: 'حذف',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
              label: const Text('إلغاء'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                widget.onItemsUpdated(_items);
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.save),
              label: const Text('حفظ التغييرات'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}