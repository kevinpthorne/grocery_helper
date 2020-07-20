import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grocery_helper/io/model.dart';
import 'package:grocery_helper/io/model_storage.dart';

typedef S StorageFactory<S>();

abstract class ModelForm<T extends Model, S extends ModelStorage>
    extends StatefulWidget {
  ModelForm(
      {Key key,
      @required this.state,
      @required this.model,
      this.readOnly = false})
      : super(key: key);

  final State<ModelForm<T, S>> state;
  final T model;
  final bool readOnly;

  @override
  State<ModelForm<T, S>> createState() => state;
}

abstract class ModelFormState<T extends Model, S extends ModelStorage>
    extends State<ModelForm<T, S>> {
  final StorageFactory<S> storageFactory;
  final _formKey = GlobalKey<FormState>();

  ModelFormState(this.storageFactory);

  void setFieldsFromModel();

  void setModelFromFields();

  @override
  void initState() {
    super.initState();
    setFieldsFromModel();
  }

  Future saveModel() async {
    setModelFromFields();
    S storage = this.storageFactory();
    await storage.write(widget.model);
    setState(() {
      setFieldsFromModel();
    });
  }

  Future deleteModel() async {
    setModelFromFields();
    S storage = this.storageFactory();
    await storage.destroy(widget.model.id);
  }

  void afterSave(BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Saved!"),
    ));
  }

  void afterDelete(BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Deleted!"),
    ));
    Navigator.pop(context);
  }

  Widget buildForm(BuildContext context);

  Widget buildActionButton(BuildContext context, SimpleAction actionDef) {
    return Padding(
      padding: EdgeInsets.all(2.0),
      child: RaisedButton(
        onPressed: () async {
          await actionDef.onPressed();
        },
        color: Theme.of(context).primaryColor,
        textColor: Theme.of(context).primaryTextTheme.bodyText1.color,
        child: actionDef.buttonChild,
      ),
    );
  }

  List<Widget> buildActionButtons(BuildContext context) {
    if (widget.readOnly) {
      return [Container()];
    } else {
      List<SimpleAction> actions = [
        SimpleAction(
            buttonChild: Text('Save'),
            onPressed: () async {
              await saveModel();
              afterSave(context);
            }),
        SimpleAction(
            buttonChild: Text('Delete'),
            onPressed: () async {
              await deleteModel();
              afterDelete(context);
            }),
      ];

      return actions.map(
          (SimpleAction actionDef) => buildActionButton(context, actionDef)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(padding: EdgeInsets.all(10), child: buildForm(context)),
    );
  }
}

class SimpleAction {
  final Function onPressed;
  final Widget buttonChild;

  SimpleAction({@required this.onPressed, @required this.buttonChild});
}
