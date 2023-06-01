include { DIAMOND_MAKEDB } from '../../modules/nf-core/diamond/makedb/main'
include { DIAMOND_BLASTX } from '../../modules/nf-core/diamond/blastx/'

workflow ALIGNMENT {
    take:
    fasta
    reference_fasta

    main:

    ch_versions = Channel.empty()

    DIAMOND_MAKEDB (
        reference_fasta
    )
    ch_versions = ch_versions.mix(DIAMOND_MAKEDB.out.versions)

    def blast_columns = "qseqid sseqid pident slen qlen length mismatch gapopen qstart qend sstart send evalue bitscore full_qseq"
    DIAMOND_BLASTX (
        fasta,
        DIAMOND_MAKEDB.out.db,
        "txt",
        blast_columns
    )

    emit:
    alignments = DIAMOND_BLASTX.out.txt
    versions = ch_versions
}
