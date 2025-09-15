
import 'dart:developer';

import 'package:blog_app/providers/theme_provider.dart';
import 'package:blog_app/widgets/neu_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_delta_from_html/parser/html_to_delta.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:provider/provider.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

class RichTextEditor extends StatefulWidget {
  final RichTextEditorController controller;

  const RichTextEditor({
    super.key,
    required this.controller,
  });

  @override
  State<RichTextEditor> createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    return Expanded(
      child: Column(
        children: [
          QuillSimpleToolbar(
            controller: widget.controller._controller,
            config: QuillSimpleToolbarConfig(
              color: isDark ? NeuColors.neuTextDark : NeuColors.neuText,
              embedButtons: FlutterQuillEmbeds.toolbarButtons(),
              showClipboardPaste: true,
              showAlignmentButtons: false,
              showBackgroundColorButton: false,
              showBoldButton: true,
              showCenterAlignment: false,
              showClearFormat: false,
              showClipboardCut: false,
              showClipboardCopy: false,
              showCodeBlock: false,
              showColorButton: false,
              showDirection: false,
              showDividers: false,
              showFontFamily: false,
              showFontSize: false,
              showHeaderStyle: false,
              showIndent: false,
              showInlineCode: false,
              showItalicButton: true,
              showJustifyAlignment: false,
              showLeftAlignment: false,
              showLink: false,
              showListBullets: true,
              showListCheck: false,
              showListNumbers: false,
              showQuote: false,
              showRedo: true,
              showRightAlignment: false,
              showSearchButton: false,
              showSmallButton: false,
              showStrikeThrough: false,
              showSubscript: false,
              showSuperscript: false,
              showUnderLineButton: true,
              showUndo: true,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: NeuContainer(
              padding: const EdgeInsets.all(8),
              isDark: isDark,
              child: QuillEditor(
                controller: widget.controller._controller,
                focusNode: widget.controller._editorFocusNode,
                scrollController: widget.controller._editorScrollController,
                config: const QuillEditorConfig(
                  scrollable: true,
                  autoFocus: false,
                  expands: false,
                  padding: EdgeInsets.zero,
                  placeholder: 'Start writing...',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RichTextEditorController extends ChangeNotifier {
  final QuillController _controller = QuillController.basic();
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();

  String get text {
    final deltajson = _controller.document.toDelta().toJson();
    final converter = QuillDeltaToHtmlConverter(deltajson);
    final html = converter.convert();
    return html;

  } // returns html string

  set text(String s) {
    if (s.trim().isEmpty) {
      _controller.document = Document();
      return;
    }

    try {
      final htmlToDelta = HtmlToDelta();
      final delta = htmlToDelta.convert(s);
      _controller.document = Document.fromDelta(delta);

      return;
    } catch (e) {
      log("Error parsing initial html document", error: e);
    }
  }
}
