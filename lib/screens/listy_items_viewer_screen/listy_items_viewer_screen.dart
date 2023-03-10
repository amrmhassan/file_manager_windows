// ignore_for_file: prefer_const_constructors

import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:windows_app/global/modals/double_buttons_modal.dart';
import 'package:windows_app/global/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:windows_app/global/widgets/screens_wrapper.dart';
import 'package:windows_app/models/listy_item_model.dart';
import 'package:windows_app/models/storage_item_model.dart';
import 'package:windows_app/providers/listy_provider.dart';
import 'package:windows_app/screens/explorer_screen/widgets/storage_item.dart';
import 'package:windows_app/utils/models_transformer_utils.dart';
import 'package:windows_app/utils/screen_utils/home_screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListyItemViewerScreen extends StatefulWidget {
  static const String routeName = '/ListyItemViewerScreen';
  const ListyItemViewerScreen({super.key});

  @override
  State<ListyItemViewerScreen> createState() => _ListyItemViewerScreenState();
}

class _ListyItemViewerScreenState extends State<ListyItemViewerScreen> {
  bool loading = true;
  String listyTitle = '';
  List<ListyItemModel> listyItems = [];
  List<StorageItemModel> storageItems = [];

  Future<List<ListyItemModel>> fetchData(String listyTitle) async {
    List<ListyItemModel> li =
        await Provider.of<ListyProvider>(context, listen: false)
            .getListyItems(listyTitle);
    return li;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      String lt = ModalRoute.of(context)!.settings.arguments as String;
      setState(() {
        listyTitle = lt;
      });
      List<ListyItemModel> i = await fetchData(lt);
      setState(() {
        loading = false;
        listyItems = i;
        storageItems = pathsToStorageItemsWithType(
                i.map((e) => {'path': e.path, 'type': e.entityType}))
            .reversed
            .toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreensWrapper(
      backgroundColor: kBackgroundColor,
      child: Column(children: [
        CustomAppBar(
          title: Text(
            listyTitle,
            style: h2TextStyle,
          ),
        ),
        loading
            ? CircularProgressIndicator()
            : storageItems.isEmpty
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No Items Here',
                          style: h4TextStyleInactive,
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: storageItems
                          .map((e) => Dismissible(
                                key: Key(e.path),
                                confirmDismiss: (direction) async {
                                  bool returnValue = false;
                                  await showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (ctx) => DoubleButtonsModal(
                                      onOk: () async {
                                        returnValue = true;
                                        await Provider.of<ListyProvider>(
                                                context,
                                                listen: false)
                                            .removeItemFromListy(
                                          path: e.path,
                                          listyTitle: listyTitle,
                                        );
                                        setState(() {
                                          storageItems.removeWhere((element) =>
                                              element.path == e.path);
                                        });
                                      },
                                      okText: 'Remove',
                                      title: 'Remove This item?',
                                    ),
                                  );
                                  return returnValue;
                                },
                                child: StorageItem(
                                  allowSelect: false,
                                  storageItemModel: e,
                                  onDirTapped: (path) =>
                                      handleOpenTabFromOtherScreen(
                                          path, context),
                                  sizesExplorer: false,
                                  parentSize: 0,
                                ),
                              ))
                          .toList(),
                    ),
                  )
      ]),
    );
  }
}
