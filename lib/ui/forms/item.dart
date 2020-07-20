import 'package:flutter/material.dart';
import 'package:grocery_helper/io/model/item.dart';
import 'package:grocery_helper/io/storage/item.dart';

import 'form.dart';

class ItemForm extends ModelForm<Item, ItemJsonStorage> {
  ItemForm({Key key, Item item, bool readOnly = false})
      : super(
            key: key, state: ItemFormState(), model: item, readOnly: readOnly);
}

class ItemFormState extends ModelFormState<Item, ItemJsonStorage> {
  TextEditingController genericItemNameController =
      new TextEditingController();
  TextEditingController itemNameController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController sizeController = new TextEditingController();

  ItemFormState() : super(() => new ItemJsonStorage());

  @override
  void setFieldsFromModel() {
    genericItemNameController.text = widget.model.genericItemName;
    itemNameController.text = widget.model.itemName;
    priceController.text = widget.model.price;
    sizeController.text = widget.model.size;
  }

  @override
  void setModelFromFields() {
    widget.model.genericItemName = genericItemNameController.text;
    widget.model.itemName = itemNameController.text;
    widget.model.price = priceController.text;
    widget.model.size = sizeController.text;
  }

  @override
  Widget buildForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Generic Item Name',
            hintText: 'Sharp Cheddar',
          ),
          controller: genericItemNameController,
          readOnly: widget.readOnly,
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Item Name',
            hintText: 'Great Value Sharp Cheddar',
          ),
          controller: itemNameController,
          readOnly: widget.readOnly,
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Price',
            hintText: '\$2.45',
          ),
          controller: priceController,
          readOnly: widget.readOnly,
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Size',
            hintText: '16oz',
          ),
          controller: sizeController,
          readOnly: widget.readOnly,
        ),
        Text('Created: ${widget.model.dateCreated.toString()}'),
        Text('Last modified: ${widget.model.dateLastModified.toString()}'),
        Text(
          'ID: ${widget.model.id}',
          textScaleFactor: 0.8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildActionButtons(context),
        )
      ],
    );
  }
}
