import 'package:did_you_buy_it/.env.dart';
import 'package:did_you_buy_it/auth/models/user_model.dart';
import 'package:did_you_buy_it/constants.dart';
import 'package:did_you_buy_it/list/models/list_model.dart';
import 'package:did_you_buy_it/list/provider/list_provider.dart';
import 'package:did_you_buy_it/list/provider/lists_provider.dart';
import 'package:did_you_buy_it/list_item/api/list_item_api.dart';
import 'package:did_you_buy_it/list_item/components/list_item_image_preview.dart';
import 'package:did_you_buy_it/list_item/components/list_item_purchase_info.dart';
import 'package:did_you_buy_it/list_item/exceptions/list_item_not_found_exception.dart';
import 'package:did_you_buy_it/list_item/forms/list_item_form.dart';
import 'package:did_you_buy_it/list_item/models/list_item_model.dart';
import 'package:did_you_buy_it/ui/widgets/slidable_action_widget.dart';
import 'package:did_you_buy_it/utils/exceptions/failed_input_validation_exception.dart';
import 'package:did_you_buy_it/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListItemTile extends StatefulWidget {
  final ListItemModel item;

  const ListItemTile({Key? key, required this.item}) : super(key: key);

  @override
  _ListItemTileState createState() => _ListItemTileState();
}

class _ListItemTileState extends State<ListItemTile> {
  List<UserModel> users = [];
  late ListModel? list;
  String? sessionUserID;

  @override
  void didChangeDependencies() {
    loadSessionUser();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, watch, Widget? child) {
        ListModel? list = watch(listProvider).list;
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          child: ListTile(
            onLongPress: () {},
            onTap: () => openItemEditForm(),
            title: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: list!.getListColor(),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    color: Colors.black,
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.item.image != null)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ListItemImagePreview(item: widget.item);
                          }));
                        },
                        child: Hero(
                          tag: "${widget.item.id}-image",
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                                child: Image(
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      '$BASE_URL${widget.item.image}'),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 5, top: 5),
                                child: Icon(
                                  Icons.zoom_out_map,
                                  size: paddingLarge * 1.2,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: paddingSmall,
                              left: paddingSmall,
                              right: paddingMedium,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.item.name,
                                  style: widget.item.purchasedAt == null
                                      ? accentElementStyle.copyWith(
                                          color: list.getFontColor(),
                                        )
                                      : itemPurchasedStyle.copyWith(
                                          decorationColor: list
                                              .getFontColor()
                                              .withAlpha(180),
                                          color: list.getFontColor(),
                                        ),
                                ),
                                if (widget.item.isRepeating)
                                  Icon(
                                    Icons.repeat,
                                    color: list.getFontColor().withAlpha(180),
                                  )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              left: paddingSmall,
                              right: paddingSmall,
                              bottom: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Divider(color: Colors.grey[300], thickness: 2),
                                Text(
                                  "Quantity: 0 //TODO",
                                  style: TextStyle(
                                    color: list.getFontColor(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.item.purchasedAt != null)
                            ListItemPurchaseInfo(item: widget.item)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            if (list.isOwner(sessionUserID))
              SlidableActionWidget(
                icon: Icons.delete,
                label: "Delete",
                color: Colors.red,
                closeOnTap: true,
                onTap: confirmDeleteListItem,
              ),
          ],
          secondaryActions: [
            if (list.isOwner(sessionUserID))
              SlidableActionWidget(
                icon: Icons.edit,
                label: "Edit",
                color: list.getSlidableActionColor(),
                foregroundColor: list.getFontColor(),
                closeOnTap: true,
                onTap: () {
                  openItemEditForm();
                },
              ),
            SlidableActionWidget(
              icon: Icons.shopping_cart_outlined,
              label: "Purchased",
              color: list.getSlidableActionColor(),
              foregroundColor: list.getFontColor(),
              onTap: updateItemBoughtState,
              closeOnTap: true,
            ),
          ],
        );
      },
    );
  }

  void openItemEditForm() {
    var list = context.read(listProvider).list;
    Navigator.of(context).pushNamed(
      ListItemForm.route_name,
      arguments: {
        "listID": list?.id,
        "item": widget.item,
      },
    );
  }

  void loadSessionUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sessionUserID = prefs.getString("user_id");
  }

  void confirmDeleteListItem() {
    showConfirmationDialog(context,
        title: "Confirm action",
        content:
            "Are you sure you want to delete the item ${widget.item.name}?",
        positiveButtonAccent: true, positiveCallback: () {
      deleteListItem();
    });
  }

  void deleteListItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(ACCESS_TOKEN_KEY);

    /*
    //TODO: find a way to validate both the list and item owner for this
    if ((list?.isOwner(sessionUserID) ?? false) == true) {
      showMsgDialog(
        context,
        message: "You don't have the permission to delete this item.",
      );
      return;
    }*/

    if (token == null) return;
    var state = context.read(listProvider);
    try {
      await ListItemApi.deleteListItem(item: widget.item, token: token);
      showMsgDialog(
        context,
        title: "Item deleted",
        message: "List item was deleted successfully",
        callBack: () {
          state.deleteItem(widget.item);
          context.read(listsProvider).updateList(state.list!);
        },
      );
    } on FailedInputValidationException catch (e) {
      showMsgDialog(context, message: "Invalid value provided for: ${e.field}");
    } on ListItemNotFoundException catch (_) {
      state.deleteItem(widget.item);
      context.read(listsProvider).updateList(state.list!);
      showMsgDialog(context, message: "List item was not found");
    } catch (_) {
      showMsgDialog(context, message: "Failed to delete a list item");
    }
  }

  void updateItemBoughtState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(ACCESS_TOKEN_KEY);

    if (token == null) return;

    var state = context.read(listProvider);
    try {
      ListItemModel item = await ListItemApi.updateListItemBoughtState(
          item: widget.item, token: token);
      showMsgDialog(
        context,
        title: "Item updated",
        message: "Purchase state updated successfully",
        callBack: () {
          state.updateItem(item);
          context.read(listsProvider).updateList(state.list!);
        },
      );
    } on FailedInputValidationException catch (e) {
      showMsgDialog(context, message: "Invalid value provided for: ${e.field}");
    } on ListItemNotFoundException catch (_) {
      state.deleteItem(widget.item);
      context.read(listsProvider).updateList(state.list!);
      showMsgDialog(context, message: "List item was not found");
    } catch (e) {
      print(e);
      showMsgDialog(
        context,
        message: "Failed to updated purchase state for the item",
      );
    }
  }
}
