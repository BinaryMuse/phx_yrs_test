use rustler::{Binary, Env, OwnedBinary, Resource, ResourceArc};
use yrs::{Doc, GetString, Text, Transact};

struct YrsWrapper {
    doc: Doc,
}

impl YrsWrapper {
    fn new() -> Self {
        YrsWrapper { doc: Doc::new() }
    }
}

#[rustler::resource_impl]
impl Resource for YrsWrapper {}

#[rustler::nif]
fn create_doc() -> ResourceArc<YrsWrapper> {
    ResourceArc::new(YrsWrapper::new())
}

#[rustler::nif]
fn set_text(wrapper: ResourceArc<YrsWrapper>, bin: Binary) -> ResourceArc<YrsWrapper> {
    {
        let text = wrapper.doc.get_or_insert_text("test");
        let mut txn = wrapper.doc.transact_mut();
        let str = String::from_utf8(bin.to_vec()).expect("failed to convert bin to str");
        text.insert(&mut txn, 0, &str);
    }

    wrapper
}

#[rustler::nif]
fn get_text(env: Env, wrapper: ResourceArc<YrsWrapper>) -> Binary {
    let text = wrapper.doc.get_or_insert_text("test");
    let txn = wrapper.doc.transact_mut();
    let str = text.get_string(&txn);
    let str_sl = str.get(0..).unwrap().as_bytes();

    let mut owned: rustler::OwnedBinary = OwnedBinary::new(str.len()).expect("Allocation failed");
    let slice = owned.as_mut_slice();

    slice.clone_from_slice(str_sl);

    Binary::from_owned(owned, env)
}

rustler::init!("Elixir.HelloPhx.YRS");
