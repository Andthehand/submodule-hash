# ⚡ submodule-hash

This GitHub Action outputs a hash of the current submodule state — ideal for **caching build artifacts that depend on submodules** in GitHub Actions workflows.

When submodules change, the hash changes, causing the cache to invalidate. This avoids rebuilding unchanged dependencies and speeds up CI.

---

## ✅ Key Features

- Outputs a stable SHA256 hash based on submodule commits  
- Enables intelligent caching of submodule builds  
- Works with mono repos or nested submodules  
- Lightweight, no dependencies  

---

## 🚀 Example Usage

Here’s a real-world example using CMake and GitHub Actions:

```yaml
jobs:
  build:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest]

    steps:
      - name: Checkout repository and submodules
        uses: actions/checkout@v4
        with:
          submodules: true

      - name: Generate submodule hash
        id: submodule-hash
        uses: Andthehand/submodule-version-hash-action@main
        with:
          path: '.'  # Root or submodule directory default is './'

      - name: Cache submodule build outputs
        id: cache-submodule
        uses: actions/cache@v4
        with:
          path: |
            vendor
            build/vendor
          key: ${{ matrix.os }}-submodules-${{ steps.submodule-hash.outputs.sha256 }}

      - name: Update git submodules (if cache miss)
        if: steps.cache-submodule.outputs.cache-hit != 'true'
        uses: actions/checkout@v4
        with:
          submodules: recursive

      - name: Configure CMake
        run: cmake -B build -DTRACY_ENABLE=OFF

      - name: Build
        run: cmake --build build --parallel
