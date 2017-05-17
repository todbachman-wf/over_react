// Copyright 2016 Workiva Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library dom_util_test;

import 'dart:html';

import 'package:over_react/over_react.dart';
import 'package:test/test.dart';

import '../../test_util/test_util.dart';
import '../../wsd_test_util/validation_util_helpers.dart';

/// Main entry point for DomUtil testing
main() {
  group('isOrContains returns', () {
    group('true when', () {
      test('root is the other element', () {
        var rootNode = renderAndGetDom(Dom.div());

        expect(isOrContains(rootNode, rootNode), isTrue);
      });

      test('root contains the other element', () {
        var rootInstance = render(DomTest());
        var rootNode = findDomNode(rootInstance);
        var otherNode = getDomByTestId(rootInstance, 'innerComponent');

        expect(isOrContains(rootNode, otherNode), isTrue);
      });
    });

    group('false when', () {
      test('root is null', () {
        var otherNode = renderAndGetDom(Dom.div()());

        expect(isOrContains(null, otherNode), isFalse);
      });

      test('other is null', () {
        var rootNode = renderAndGetDom(Dom.div()());

        expect(isOrContains(rootNode, null), isFalse);
      });

      test('root and other is null', () {
        expect(isOrContains(null, null), isFalse);
      });

      test('root is not, or does not contain, the other element', () {
        var rootNode = renderAndGetDom(Dom.div()());
        var otherNode = renderAndGetDom(Dom.div()());

        expect(isOrContains(rootNode, otherNode), isFalse);
      });
    });
  });

  group('closest', () {
    group('returns the closest node that matches the given selector', () {
      test('when the child matches the target selector in addition to its parent', () {
        var parent = new DivElement()..className = 'target-class';
        var child = new DivElement()..className = 'target-class';
        parent.append(child);

        expect(closest(child, '.target-class'), child);
      });

      test('when the parent matches the target selector in addition to its grandparent', () {
        var grandparent = new DivElement()..className = 'target-class';
        var parent = new DivElement()..className = 'target-class';
        var child = new DivElement();
        grandparent.append(parent);
        parent.append(child);

        expect(closest(child, '.target-class'), parent);
      });

      test('when only the granparent matches the target selector', () {
        var grandparent = new DivElement()..className = 'target-class';
        var parent = new DivElement();
        var child = new DivElement();
        grandparent.append(parent);
        parent.append(child);

        expect(closest(child, '.target-class'), grandparent);
      });

      test('when an `upperBound` is set that includes the matching ancestor', () {
        var grandparent = new DivElement()..className = 'target-class';
        var parent = new DivElement();
        var child = new DivElement();
        grandparent.append(parent);
        parent.append(child);

        expect(closest(child, '.target-class', upperBound: grandparent), grandparent);
      });

      test('when an `upperBound` is set the same as `lowerBound`, which matches', () {
        var element = new DivElement()..className = 'target-class';
        expect(closest(element, '.target-class', upperBound: element), element);
      });
    });

    group('returns null', () {
      test('when there are no matching elements', () {
        var grandparent = new DivElement();
        var parent = new DivElement();
        var child = new DivElement();
        grandparent.append(parent);
        parent.append(child);

        expect(closest(child, '.target-class'), isNull);
      });

      test('when an `upperBound` is set to exclude any matching elements', () {
        var grandparent = new DivElement()..className = 'target-class';
        var parent = new DivElement();
        var child = new DivElement();
        grandparent.append(parent);
        parent.append(child);

        expect(closest(child, '.target-class', upperBound: parent), isNull);
      });
    });
  });

  group('getActiveElement returns the correct value when the active element is', () {
    test('a valid element other than document.body', () async {
      var activeElement = new DivElement()..tabIndex = 1;
      document.body.children.add(activeElement);

      await triggerFocus(activeElement);

      expect(getActiveElement(), activeElement);
      activeElement.remove();
    });

    test('document.body', () {
      document.body.focus();

      expect(getActiveElement(), isNull);
    });
  });

  group('setSelectionRange and getSelectionStart: ', () {
    test('setSelectionRange throws an ArgumentError if called on an unsupported Element type', () {
      var invalidElement = new DivElement();

      expect(() => setSelectionRange(invalidElement, 0, 0), throwsArgumentError);
      expect(() => getSelectionStart(invalidElement), returnsNormally);
    });

    test('setSelectionRange throws an ArgumentError if called on an unsupported InputElement type', () {
      var invalidElement = new CheckboxInputElement();

      // Note: For some unknown reason - when running the exact same expect() we use for DivElement above,
      // this one fails with "Invalid Object" - the stack trace never leaves test()
      //
      // ¯\_(ツ)_/¯
      var setSelectionError;
      var getSelectionError;

      try {
        setSelectionRange(invalidElement, 0, 0);
      } catch (err) {
        setSelectionError = err;
      }

      try {
        getSelectionStart(invalidElement);
      } catch (err) {
        getSelectionError = err;
      }

      expect(setSelectionError, isNotNull);
      expect(getSelectionError, isNull);
    });

    group('correctly call their respective methods', () {
      var renderedInstance;
      InputElement inputElement;
      TextAreaElement textareaElement;
      const String testValue = 'foo';

      tearDown(() {
        renderedInstance = null;
        inputElement = null;

        tearDownAttachedNodes();
      });

      group('on an `<input>` of type:', () {
        void sharedInputSetSelectionRangeTest(String type) {
          renderedInstance = renderAttachedToDocument((Dom.input()
            ..defaultValue = testValue
            ..type = type
          )());
          inputElement = findDomNode(renderedInstance);
          setSelectionRange(inputElement, testValue.length, testValue.length);

          // setSelectionRange on number inputs shouldn't throw in other browsers,
          // but it also doesn't always work.
          // Don't expect that the selection actually changed.
          if (type != 'number') {
            expect(inputElement.selectionStart, equals(testValue.length));
            expect(inputElement.selectionEnd, equals(testValue.length));
          }
        }

        void sharedInputGetSelectionStartTest(String type) {
          renderedInstance = renderAttachedToDocument((Dom.input()
            ..defaultValue = testValue
            ..type = type
          )());
          inputElement = findDomNode(renderedInstance);
          var selectionStart = getSelectionStart(inputElement);

          if (type == 'email' || type == 'number') {
            expect(selectionStart, isNull);
          } else {
            expect(selectionStart, testValue.length);
          }
        }

        for (var type in inputTypesWithSelectionRangeSupport) {
          test(type, () { sharedInputGetSelectionStartTest(type); });

          if (type == 'email' || type == 'number') {
            // See: https://bugs.chromium.org/p/chromium/issues/detail?id=324360
            test(type, () {
              sharedInputSetSelectionRangeTest(type);
            }, testOn: 'js && !chrome');
          } else {
            test(type, () { sharedInputSetSelectionRangeTest(type); });
          }
        }
      });

      test('on TextAreaElement', () {
        renderedInstance = renderAttachedToDocument((Dom.textarea()
          ..defaultValue = testValue
        )());
        textareaElement = findDomNode(renderedInstance);
        setSelectionRange(textareaElement, testValue.length, testValue.length);

        expect(textareaElement.selectionStart, equals(testValue.length));
        expect(textareaElement.selectionEnd, equals(testValue.length));

        var selectionStart = getSelectionStart(textareaElement);

        expect(selectionStart, testValue.length);
      });

      // See: https://bugs.chromium.org/p/chromium/issues/detail?id=324360
      group('without throwing an error in Google Chrome when `props.type` is', () {
        void verifyLackOfException() {
          expect(renderedInstance, isNotNull, reason: 'test setup sanity check');
          expect(inputElement, isNotNull, reason: 'test setup sanity check');

          expect(() => setSelectionRange(inputElement, testValue.length, testValue.length), returnsNormally);
          expect(() => getSelectionStart(inputElement), returnsNormally);
        }

        setUp(() {
          startRecordingValidationWarnings();
        });

        tearDown(() {
          stopRecordingValidationWarnings();
        });

        test('email', () {
          renderedInstance = renderAttachedToDocument((Dom.input()
            ..defaultValue = testValue
            ..type = 'email'
          )());
          inputElement = findDomNode(renderedInstance);
          verifyLackOfException();
        });

        test('number', () {
          renderedInstance = renderAttachedToDocument((Dom.input()
            ..defaultValue = testValue
            ..type = 'number'
          )());
          inputElement = findDomNode(renderedInstance);
          verifyLackOfException();
        });
      }, testOn: 'chrome');
    });
  });
}

@Factory()
UiFactory<DomTestProps> DomTest;

@Props()
class DomTestProps extends UiProps {}

@Component()
class DomTestComponent extends UiComponent<DomTestProps> {
  @override
  render() {
    return Dom.div()(
      (Dom.div()..addTestId('innerComponent'))()
    );
  }
}
