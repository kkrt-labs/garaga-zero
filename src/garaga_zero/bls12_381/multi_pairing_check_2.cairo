from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin, UInt384
from garaga_zero.definitions import bls, G1G2Pair, TRUE

from garaga_zero.precompiled_circuits.multi_pairing_check_bls12_381_2 import (
    get_BLS12_381_MULTI_PAIRING_CHECK_2_circuit,
)
from garaga_zero.modulo_circuit import run_extension_field_modulo_circuit
from garaga_zero.ec_ops import all_g1_g2_pairs_are_on_curve

func multi_pairing_check_2P{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(input: G1G2Pair*) {
    alloc_locals;
    let n_pairs = 2;
    let (all_on_curve) = all_g1_g2_pairs_are_on_curve(input, n_pairs, bls.CURVE_ID);
    assert all_on_curve = TRUE;

    let (circuit) = get_BLS12_381_MULTI_PAIRING_CHECK_2_circuit();
    let (_, _) = run_extension_field_modulo_circuit(circuit, cast(input, felt*));

    // Check is implicitely made by the circuit.
    return ();
}
