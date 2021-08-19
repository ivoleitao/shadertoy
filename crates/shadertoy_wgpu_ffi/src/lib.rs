//! This crate provides C ABI interface for [shadertoy-wgpu](https://crates.io/crate/shadertoy-wgpu) crate.
//!
//! # Bindings generation
//!
//! Among library creation this crate generates `shadertoy_wgpu_ffi.h` file, enabled by default by `cbindgen` feature,
//! which might be useful for automatic bindings generation or just with plain `C`/`C++` development.
//!
//! After build it will be located somewhere at `target/*/build/shadertoy-wgpu-ffi-*/out/`,
//! depending on build profile (`debug`/`release`) and build hash.
//!
//! Disabling `cbindgen` feature might speed up compilation a little bit,
//! especially if you don't need the header file.
//!
//! # Examples
//!
//! ```c
//! #include "shadertoy_wgpu_ffi.h"
//!
//! void main() {
//!    Renderer *renderer = shadertoy_wgpu_renderer_new();
//!    // .. handle `renderer == NULL` here ..
//!    // .. use some renderer functions here
//!    shadertoy_wgpu_renderer_free(manager);
//! }
//! ```
//!
//! Also, check the `examples/` directory in the repository for examples with Dart

mod errors;
mod renderer;

/// Opaque struct representing a shadertoy wgpu renderer.
///
/// End users should consider it as a some memory somewhere in the heap,
/// and work with it only via library methods.
pub type Renderer = shadertoy_wgpu::Renderer;
