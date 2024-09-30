use rustler::{Binary, Env, NewBinary, Resource, ResourceArc};
use yrs::{updates::decoder::Decode, Doc, ReadTxn, StateVector, Transact, Update};

struct YrsWrapper {
    doc: Doc,
}

impl YrsWrapper {
    fn new() -> Self {
        let doc = Doc::new();
        doc.get_or_insert_xml_fragment("document-store");
        YrsWrapper { doc }
    }
}

#[rustler::resource_impl]
impl Resource for YrsWrapper {}

#[rustler::nif]
fn create_doc() -> ResourceArc<YrsWrapper> {
    ResourceArc::new(YrsWrapper::new())
}

#[rustler::nif]
fn apply_update(wrapper: ResourceArc<YrsWrapper>, update: Binary) -> ResourceArc<YrsWrapper> {
    {
        let mut txn = wrapper.doc.transact_mut();
        txn.apply_update(Update::decode_v1(update.as_slice()).unwrap())
            .expect("could not applly update to doc");
    }

    wrapper
}

#[rustler::nif]
fn get_update_for_load<'a>(
    env: Env<'a>,
    wrapper: ResourceArc<YrsWrapper>,
    enc_state_vector: Binary,
) -> Binary<'a> {
    let txn = wrapper.doc.transact_mut();
    let state_vec_slice = enc_state_vector.as_slice();
    let state_vec = StateVector::decode_v1(state_vec_slice).unwrap();
    let update = txn.encode_diff_v1(&state_vec);

    let mut bin = NewBinary::new(env, update.len());
    bin.as_mut_slice().clone_from_slice(update.as_slice());
    Binary::try_from(bin).unwrap()
}

rustler::init!("Elixir.HelloPhx.YRS");
