;; flycheck-falco-rules-test.el --- Flycehck falco rules: Test suite
;; SPDX-License-Identifier: Apache-2.0
;;
;; Copyright (C) 2022 The Falco Authors.
;;
;;
;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at
;;
;;     http://www.apache.org/licenses/LICENSE-2.0
;;
;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.
;;

;;; Commentary:

;; The test suite for flycheck-falco-rules

;;; Code:

(require 'flycheck-ert)
(require 'flycheck-falco-rules)
(require 'yaml-mode)

(message "Running tests on Emacs %s" emacs-version)

(defconst flycheck-falco-rules-test-directory
  (let ((filename (if load-in-progress load-file-name (buffer-file-name))))
    (expand-file-name "test/" (locate-dominating-file filename "Cask")))
  "Test suite directory, for resource loading.")

(flycheck-ert-def-checker-test falco-rules falco-rules example-warnings-error
			       (let ((flycheck-checkers '(falco-rules))
				     (flycheck-ert-checker-wait-time 300)
				     (flycheck-falco-rules-validate-command "falco -o json_output=True -V"))
				 (flycheck-ert-should-syntax-check
				  "example_warnings_error.yaml" 'yaml-mode
				  '(3 3 warning "Unknown top level item" :id "LOAD_UNKNOWN_ITEM" :checker falco-rules)
				  '(11 3 warning "Rule matches too many evt.type values. This has a significant performance penalty." :id "LOAD_NO_EVTTYPE" :checker falco-rules)
				  '(17 3 warning "Unknown source my-cloud, skipping" :id "LOAD_UNKNOWN_SOURCE" :checker falco-rules)
				  '(26 14 warning "filter_check called with nonexistent field proc.nobody" :id "LOAD_UNKNOWN_FIELD" :checker falco-rules)
				  '(33 14 error "unexpected token after 'not', expecting 'or', 'and'" :id "LOAD_ERR_COMPILE_CONDITION" :checker falco-rules))))

(flycheck-ert-initialize flycheck-falco-rules-test-directory)

(provide 'flycheck-falco-rules-test)

;;; flycheck-falco-rules-test.el ends here
