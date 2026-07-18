#!/bin/bash
# script/setup_git_hooks.sh

HOOKS_DIR=".git/hooks"
PRE_PUSH_HOOK="$HOOKS_DIR/pre-push"

echo "Setting up pre-push git hook..."

cat << 'EOF' > "$PRE_PUSH_HOOK"
#!/bin/bash
# Pre-push hook to run formatting and analysis

echo "Running pre-push checks..."
cd transcriberapp || exit 1

echo "1. Checking formatting..."
dart format --set-exit-if-changed .
if [ $? -ne 0 ]; then
  echo "❌ Code formatting issues found. Please run 'dart format .' and commit the changes."
  exit 1
fi

echo "2. Running analyzer..."
flutter analyze
if [ $? -ne 0 ]; then
  echo "❌ Analyzer found issues. Please fix them before pushing."
  exit 1
fi

echo "✅ All checks passed. Pushing..."
exit 0
EOF

chmod +x "$PRE_PUSH_HOOK"
echo "✅ Git hooks configured successfully!"
